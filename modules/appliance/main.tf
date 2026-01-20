module "appliance" {
  source = "./server"
  proxmox_endpoint = var.proxmox_endpoint
  proxmox_api_user = var.proxmox_api_user
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user = var.proxmox_user
  proxmox_password = var.proxmox_password
  server_name = var.server_name
  vm_id = var.vm_id
  size = var.size
  datastore_id = var.datastore_id
  ssh_public_keys = var.ssh_public_keys
  networks = length(var.networks) > 0 ? var.networks : [ { bridge = "vmbr0", address = "dhcp" } ]
  source_vm_id = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username = var.username
}