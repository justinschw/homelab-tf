terraform {
  backend "s3" {}
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "3.13.1"
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

provider "minio" {
  minio_server   = var.minio_endpoint
  minio_user     = var.minio_access_key
  minio_password = var.minio_secret_key
  minio_region   = var.minio_region
  minio_ssl      = var.minio_use_ssl
  minio_insecure = var.minio_skip_verify
}

module "appliance" {
  source = "./server"
  providers = {
    proxmox = proxmox
  }
  proxmox_endpoint    = var.proxmox_endpoint
  proxmox_api_user    = var.proxmox_api_user
  proxmox_api_token   = var.proxmox_api_token
  proxmox_node_name   = var.proxmox_node_name
  proxmox_user        = var.proxmox_user
  proxmox_password    = var.proxmox_password
  server_name         = var.server_name
  vm_id               = var.vm_id
  size                = var.size
  datastore_id        = var.datastore_id
  data_disk_size_gb   = var.data_disk_size_gb
  ssh_public_keys     = var.ssh_public_keys
  networks            = length(var.networks) > 0 ? var.networks : [{ bridge = "vmbr0", address = "dhcp" }]
  source_vm_id        = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username            = var.username
}

resource "minio_s3_object" "ansible_inventory" {
  bucket_name = var.bucket_name
  object_name = "${var.server_name}/ansible/ansible-inventory.ini"
  content = templatefile("${path.module}/inventory.tpl", {
    server_name = var.server_name
    domain      = var.domain_name
    username    = var.username
  })
  content_type = "text/plain"
}
