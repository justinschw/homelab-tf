# Provider auth
variable "proxmox_endpoint" {
    type = string
}

variable "proxmox_api_token" {
    type = string
}

# Network auth
variable "proxmox_node_name" {
    type = string
}

variable "proxmox_egress_port" {
    type = string
    default = "eno1"
}

variable "proxmox_egress_ip" {
    type = string
    default = "10.87.1.19/24"
}

variable "proxmox_egress_gateway" {
    type = string
    default = "10.87.1.254"
}

variable "proxmox_mgmt_network" {
    type = string
    default = "vmbr0"
}
