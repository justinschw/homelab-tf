terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.70.0"
    }
  }
  backend "s3" {
    bucket = var.state_bucket
    endpoints = {
      s3 = var.s3_endpoint
    }
    key    = var.state_filename
    region = var.state_region
    access_key = var.s3_access_key
    secret_key = var.s3_secret_key
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  api_token = "${var.proxmox_api_user}!${var.proxmox_api_token}"
  insecure = true
  ssh {
    agent = false
    username = var.proxmox_user
    password = var.proxmox_password
  }
}

locals {
    cpu_cores = lookup({
        "small" = 1
        "medium" = 2
        "large" = 4
    }, var.size, 2)
    mem = lookup({
        "small" = 2048
        "medium" = 4096
        "large" = 8192
    }, var.size, 4096)
    disk_size = lookup({
        "small" = 20
        "medium" = 40
        "large" = 80
    }, var.size, 40)
}

resource "proxmox_virtual_environment_vm" "cloned_vm" {
  name      = var.server_name
  node_name = var.proxmox_node_name
  stop_on_destroy = true

  clone {
    datastore_id = var.source_vm_datastore
    vm_id        = var.source_vm_id
    full = true
    node_name = var.proxmox_node_name
    retries = 3
  }
  
  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }

  cpu {
    cores = local.cpu_cores
    type = "x86-64-v2-AES"
  }

  memory {
    dedicated = local.mem
    floating = local.mem
  }
  
  initialization {

    dynamic "ip_config" {
      for_each = var.networks
      content {
        ipv4 {
          address = ip_config.value.address
        }
      }
    }

    user_account {
      username = var.username
      keys     = [for k in var.ssh_public_keys : trimspace(k)]
    }

  }

  disk {
    datastore_id = var.datastore_id
    file_id      = var.server_image_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.disk_size != "" ? tonumber(var.disk_size) : local.disk_size
  }

  dynamic "network_device" {
    for_each = var.networks
    content {
      bridge = network_device.value.bridge
    }
  }

}
