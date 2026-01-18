terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.70.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure = true
  ssh {
    agent = true
  }
}

# Configure networks

resource "proxmox_virtual_environment_network_linux_bridge" "net_egress" {
  node_name = var.proxmox_node_name
  name      = "vmbr1"
  comment = "WAN network"
  # Host networking info
  address = var.proxmox_egress_ip
  gateway = var.proxmox_egress_gateway
  autostart = true
  ports = [
    var.proxmox_egress_port
  ]
}

resource "proxmox_virtual_environment_network_linux_bridge" "net_home" {
  node_name = var.proxmox_node_name
  name      = "vmbr2"
  comment = "Home network"
}

resource "proxmox_virtual_environment_network_linux_bridge" "net_lab" {
  node_name = var.proxmox_node_name
  name      = "vmbr3"
  comment = "Lab network"
}

resource "proxmox_virtual_environment_network_linux_bridge" "net_minecraft" {
  node_name = var.proxmox_node_name
  name      = "vmbr4"
  comment = "Isolated network for minecraft server"
}

resource "proxmox_virtual_environment_network_linux_bridge" "net_storage" {
  node_name = var.proxmox_node_name
  name      = "vmbr5"
  comment = "Isolated network for NAS"
}

# Note: Firewall must be created manually