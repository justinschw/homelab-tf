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

variable "server_download_file" {
    type = string
}

variable "server_target_file" {
    type = string
}