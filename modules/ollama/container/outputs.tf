output "vmid" {
  value       = proxmox_virtual_environment_container.ollama.vm_id
  description = "VMID of the created container"
}

output "hostname" {
  value       = proxmox_virtual_environment_container.ollama.initialization[0].hostname
  description = "Hostname of the container"
}
