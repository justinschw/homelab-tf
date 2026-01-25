output "server_name" {
  value = var.server_name
}

output "hostname" {
  value = "${var.server_name}.${var.domain_name}"
}

output "mac" {
  value = proxmox_virtual_environment_vm.cloned_vm.network[0].mac_address
}
