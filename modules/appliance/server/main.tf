terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.70.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${var.proxmox_endpoint}"
  api_token = "${var.proxmox_api_user}=${var.proxmox_api_token}"
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
}

resource "proxmox_virtual_environment_file" "network_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.proxmox_node_name

  source_raw {
    data = templatefile("${path.module}/network-data.tpl", {
      networks = var.networks
      hostname  = var.server_name
    })

    file_name = "network-data-${var.server_name}.yaml"
  }
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

  // ...existing code...
  dynamic "disk" {
    for_each = var.data_disk_size_gb > 0 ? [1] : []
    content {
      size         = var.data_disk_size_gb
      datastore_id = var.datastore_id
      interface    = "virtio0"
      discard      = "on"
      file_format  = "raw"
      iothread     = true
    }
  }
  
  initialization {
    network_data_file_id = proxmox_virtual_environment_file.network_data.id

    user_account {
      username = var.username
      keys     = [for k in var.ssh_public_keys : trimspace(k)]
    }
  }

  dynamic "network_device" {
    for_each = var.networks
    content {
      bridge = network_device.value.bridge
      firewall = true
    }
  }

}
