# Provider auth
variable "proxmox_endpoint" {
    type = string
    required = true
}

variable "proxmox_api_user" {
    type = string
    sensitive = true
    required = true
}

variable "proxmox_api_token" {
    type = string
    sensitive = true
    required = true
}

variable "proxmox_node_name" {
    type = string
    default = "nexus"
}

variable "proxmox_user" {
    type = string
    sensitive = true
    required = true
}

variable "proxmox_password" {
    type = string
    sensitive = true
    required = true
}

variable "server_image_id" {
    type = string
}

# VM info

variable "server_name" {
    type = string
    required = true
}

variable "vm_id" {
    type = number
    default = 100
}

variable "size" {
    type = string
    validation {
        condition = can(regex("^(small|medium|large)$", var.size))
        error_message = "Must be small, medium or large"
    }
}

variable "ssh_public_keys" {
    type = list(string)
    default = []
}

variable "networks" {
    description = "List of network objects with fields `bridge` and `address` (e.g. address can be 'dhcp' or CIDR)."
    type = list(object({
        bridge = string
        address = string
    }))
    default = [
        {
            bridge = "vmbr0"
            address = "dhcp"
        }
    ]
}

variable datastore_id {
    type = string
    default = "vm-tank"
}

variable disk_size {
    type = string
}

# User info
variable username {
    type = string
    default = "homelab"
}

variable "source_vm_datastore" {
    description = "Datastore of the source VM to clone from"
    type = string
    default = "vm-tank"
}

variable "source_vm_id" {
    description = "When non-zero, clone from this source VM ID"
    type = number
    default = 0
}
