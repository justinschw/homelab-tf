terraform {
  backend "local" {}
}

module "appliance" {
  source = "./server"
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  server_image_id = var.server_image_id
  server_name = var.server_name
  vm_id = var.vm_id
  size = var.size
  ip_address = var.ip_address
  pubkey_path = var.pubkey_path
  mgmt_bridge = var.mgmt_bridge
  lan_bridge = var.lan_bridge
  username = var.username
}