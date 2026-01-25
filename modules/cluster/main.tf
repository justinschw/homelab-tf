terraform {
  backend "s3" {}
  required_providers {
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.17.0"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.0"
    }
    pfsense = {
      source  = "marshallford/pfsense"
      version = "0.20.0"
    }
    dns = {
      source  = "hashicorp/dns"
      version = ">= 3.4.3"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.proxmox_endpoint}"
  api_token = "${var.proxmox_api_user}=${var.proxmox_api_token}"
  insecure  = true
  ssh {
    agent    = false
    username = var.proxmox_user
    password = var.proxmox_password
  }
}

provider "bitwarden" {
  email           = var.bitwarden_email
  master_password = var.bitwarden_password
  client_id       = var.bitwarden_client_id
  client_secret   = var.bitwarden_client_secret
}

provider "pfsense" {
  alias           = "pfsense"
  url             = var.pfsense_config.url
  username        = var.pfsense_config.username
  password        = var.pfsense_config.password
  tls_skip_verify = var.pfsense_config.tls_skip_verify
}

module "master" {
  source = "../appliance/server"
  providers = {
    proxmox = proxmox
  }
  proxmox_endpoint    = var.proxmox_endpoint
  proxmox_api_user    = var.proxmox_api_user
  proxmox_api_token   = var.proxmox_api_token
  proxmox_node_name   = var.proxmox_node_name
  proxmox_user        = var.proxmox_user
  proxmox_password    = var.proxmox_password
  server_name         = "${var.cluster_name}-master"
  vm_id               = var.vm_ids[0]
  size                = "medium"
  datastore_id        = var.datastore_id
  ssh_public_keys     = var.ssh_public_keys
  networks            = length(var.networks) > 0 ? var.networks : [{ bridge = "vmbr0", address = "dhcp" }]
  source_vm_id        = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username            = var.username
}

module "worker_pool" {
  for_each = { for idx, id in var.vm_ids : idx => id if idx != 0 }
  source   = "../appliance/server"
  providers = {
    proxmox = proxmox
  }
  proxmox_endpoint    = var.proxmox_endpoint
  proxmox_api_user    = var.proxmox_api_user
  proxmox_api_token   = var.proxmox_api_token
  proxmox_node_name   = var.proxmox_node_name
  proxmox_user        = var.proxmox_user
  proxmox_password    = var.proxmox_password
  server_name         = "${var.cluster_name}-worker-${each.key}"
  vm_id               = each.value
  size                = "small"
  datastore_id        = var.datastore_id
  ssh_public_keys     = var.ssh_public_keys
  networks            = length(var.networks) > 0 ? var.networks : [{ bridge = "vmbr0", address = "dhcp" }]
  source_vm_id        = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username            = var.username
}

resource "bitwarden_folder" "clusterinfo" {
  name = "${var.cluster_name}-info"
}

resource "bitwarden_item_secure_note" "ansible_inventory" {
  folder_id = bitwarden_folder.clusterinfo.id
  name      = "${var.cluster_name}-ansible-inventory"
  notes = templatefile("${path.module}/inventory.tpl", {
    master   = module.master
    domain   = var.domain_name
    username = var.username
    worker = [
      for _, v in module.worker_pool : {
        server_name = v.server_name
      }
    ]
  })
}

# Get IP addresses of all VMs from DNS
data "dns_a_record_set" "vm_ips" {
  for_each = {
    for vm in concat([module.master], values(module.worker_pool)) :
    vm.server_name => vm
  }
  host = "${each.value.server_name}.${var.domain_name}"
}

# Add static DHCP mappings in pfSense for all VMs
resource "pfsense_dhcpv4_staticmapping" "dhcp_mappings" {
  provider = pfsense.pfsense
  for_each = {
    for vm in concat([module.master], values(module.worker_pool)) :
    vm.server_name => vm
  }
  interface         = "lan"
  mac_address       = each.value.mac
  ip_address        = data.dns_a_record_set.vm_ips[each.key].addresses[0]
  hostname          = each.value.hostname
  description       = "Static DHCP mapping for ${each.value.hostname}"
  client_identifier = each.value.server_name
}
