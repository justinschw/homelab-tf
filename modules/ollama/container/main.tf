terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 1.0.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "ollama" {
  description = "Ollama LXC container with GPU access"
  
  node_name = var.node_name
  vm_id     = var.vmid

  unprivileged = false

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
    swap      = var.swap
  }

  disk {
    datastore_id = var.storage
    size         = tonumber(regex("([0-9]+)", var.rootfs_size)[0])
  }

  operating_system {
    template_file_id = var.template
    type             = "ubuntu"
  }

  network_interface {
    name   = "veth0"
    bridge = var.mgmt_bridge
  }

  initialization {
    hostname = var.hostname
    
    dns {
      servers = var.nameserver != "" ? [var.nameserver] : []
      domain  = var.searchdomain
    }

    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }

    user_account {
      keys     = var.ssh_authorized_keys != "" ? [var.ssh_authorized_keys] : []
      password = var.root_password != "" ? var.root_password : null
    }
  }

  features {
    nesting = true
    keyctl  = true
  }

  # Pass through NVIDIA GPU devices to the container
  # Note: Additional manual configuration may be required for full GPU access
  # The Proxmox configuration file /etc/pve/lxc/<vmid>.conf may need manual edits
  # to add: lxc.cgroup.devices.allow and lxc.mount.entry directives
  device_passthrough {
    path = "/dev/nvidia0"
  }

  device_passthrough {
    path = "/dev/nvidiactl"
  }

  device_passthrough {
    path = "/dev/nvidia-uvm"
  }

  device_passthrough {
    path = "/dev/nvidia-modeset"
  }

  device_passthrough {
    path = "/dev/dri"
  }

  tags = var.tags

  started = true
}
