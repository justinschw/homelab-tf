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

# Private cluster network
resource "proxmox_virtual_environment_network_linux_bridge" "cluster_network" {
  node_name = var.proxmox_node_name
  bridge    = var.cluster_network_bridge
  type      = "bridge"
  autostart = true
  address   = var.cluster_network_cidr
}

module "master" {
  source = "../appliance/server"
  providers = {
    proxmox = proxmox
  }
  proxmox_endpoint  = var.proxmox_endpoint
  proxmox_api_user  = var.proxmox_api_user
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user      = var.proxmox_user
  proxmox_password  = var.proxmox_password
  server_name       = "${var.cluster_name}-master"
  vm_id             = var.vm_ids[0]
  size              = "medium"
  datastore_id      = var.datastore_id
  ssh_public_keys   = var.ssh_public_keys
  networks = concat(var.networks, [{
    bridge  = var.cluster_network_bridge,
    address = cidrhost(var.cluster_network_cidr, 10)
  }])
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
  proxmox_endpoint  = var.proxmox_endpoint
  proxmox_api_user  = var.proxmox_api_user
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user      = var.proxmox_user
  proxmox_password  = var.proxmox_password
  server_name       = "${var.cluster_name}-worker-${each.key}"
  vm_id             = each.value
  size              = "small"
  datastore_id      = var.datastore_id
  ssh_public_keys   = var.ssh_public_keys
  networks = concat(var.networks, [{
    bridge  = var.cluster_network_bridge,
    address = cidrhost(var.cluster_network_cidr, 20 + each.key)
  }])
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
