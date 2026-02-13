terraform {
  backend "s3" {}
  required_providers {
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

resource "proxmox_virtual_environment_container" "container" {
  vm_id     = var.vm_id
  node_name = var.node

  initialization {
    hostname = var.hostname
    ip_config {
      ipv4 {
        address = var.ip_address
      }
    }

    user_account {
      keys = [for k in var.ssh_public_keys : trimspace(k)]
    }
  }

  network_interface {
    name = var.net_bridge
  }

  disk {
    datastore_id = var.storage_pool
    size         = var.disk_size
  }

  operating_system {
    template_file_id = var.template
    type             = var.type
  }

  cpu {
    cores = var.cpus
  }

  memory {
    dedicated = var.memory
  }

  start_on_boot = true
}

