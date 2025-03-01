# Provider auth
variable "proxmox_endpoint" {
    type = string
}

variable "proxmox_api_token" {
    type = string
}

variable "proxmox_node_name" {
    type = string
    default = "nexus"
}

variable "proxmox_user" {
    type = string
}

variable "proxmox_password" {
    type = string
}

variable "server_image_id" {
    type = string
}

# VM info

variable "server_name" {
    type = string
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

variable "ip_address" {
    type = string
}

variable pubkey_path {
    type = string
}

variable mgmt_bridge {
    type = string
    default = "vmbr0"
}

variable lan_bridge {
    type = string
    default = "vmbr2"
}

# User info
variable username {
    type = string
    default = "homelab"
}
