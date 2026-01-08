output "vmid" {
  value       = module.container.vmid
  description = "VMID of the created container"
}

output "hostname" {
  value       = module.container.hostname
  description = "Hostname of the container"
}

output "ip_address" {
  value       = var.ip_address
  description = "Configured IP address"
}
