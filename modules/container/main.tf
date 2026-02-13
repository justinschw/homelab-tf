terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.0"
    }
  }
}

resource "proxmox_lxc" "container" {
  vmid = var.vmid
  node = var.node

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

