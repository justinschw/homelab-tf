output "server_name" {
  value = var.server_name
}

output "hostname" {
  value = "${var.server_name}.${var.domain_name}"
}

output "mac" {
  value = proxmox_virtual_environment_vm.cloned_vm.network_device[0].mac_address
}

output "networks" {
  value = var.networks
}