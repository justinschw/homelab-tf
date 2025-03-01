terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.70.0"
    }
  }
  backend "local" {
    path = var.state_path
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure = true
  ssh {
    agent = false
    username = var.proxmox_user
    password = var.proxmox_password
  }
}

data "local_file" "ssh_public_key" {
  filename = var.pubkey_path
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

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = var.server_name
  node_name = var.proxmox_node_name

  stop_on_destroy = true
  
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

    # MGMT interface
    ip_config {
        ipv4 {
            address = var.ip_address
        }
    }

    # LAN interface
    ip_config {
        ipv4 {
            address = "dhcp"
        }
    }

    user_account {
      username = var.username
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }

  }

  disk {
    datastore_id = "local-lvm"
    file_id      = var.server_image_id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  network_device {
    bridge = var.mgmt_bridge
  }

  network_device {
    bridge = var.lan_bridge
  }

}
