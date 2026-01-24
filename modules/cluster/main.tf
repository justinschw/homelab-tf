terraform {
  backend "s3" {}
  required_providers {
    bitwarden = {
      source = "bitwarden/bitwarden"
      version = ">= 1.17.0"
    }
  }
}

provider "bitwarden" {
  email            = var.bitwarden_email
  master_password  = var.bitwarden_password
  client_id        = var.bitwarden_client_id
  client_secret    = var.bitwarden_client_secret
}

module "master" {
  source = "../appliance/server"
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_api_user = var.proxmox_api_user
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  server_name = "${var.cluster_name}-master"
  vm_id = var.vm_ids[0]
  size = "medium"
  datastore_id = var.datastore_id
  ssh_public_keys = var.ssh_public_keys
  networks = length(var.networks) > 0 ? var.networks : [ { bridge = "vmbr0", address = "dhcp" } ]
  source_vm_id = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username = var.username
}

module "worker_pool" {
  for_each = { for idx, id in var.vm_ids : idx => id if idx != 0 }
  source = "../appliance/server"
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_api_user = var.proxmox_api_user
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  server_name = "${var.cluster_name}-worker-${worker.key}"
  vm_id = worker.value
  size = "small"
  datastore_id = var.datastore_id
  ssh_public_keys = var.ssh_public_keys
  networks = length(var.networks) > 0 ? var.networks : [ { bridge = "vmbr0", address = "dhcp" } ]
  source_vm_id = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username = var.username
}

resource "bitwarden_folder" "clusterinfo" {
  name = "${var.cluster_name}-info"
}

resource "bitwarden_item_secure_note" "ansible_inventory" {
  folder_id = bitwarden_folder.clusterinfo.id
  name      = "${var.cluster_name}-ansible-inventory"
  notes     = << EOT
  [masters]
  ${module.master.server_name} ansible_host=${module.master.ip_address} ansible_user=${var.username}
  [workers]
  %{ for w in worker.value ~}
  ${w.server_name} ansible_host=${w.ip_address} ansible_user=${var.username}
  %{ endfor ~}
  EOT
}