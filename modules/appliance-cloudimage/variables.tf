# Provider auth
variable "proxmox_endpoint" {
  type = string
}

variable "proxmox_api_user" {
  type      = string
  sensitive = true
}

variable "proxmox_api_token" {
  type      = string
  sensitive = true
}

variable "proxmox_node_name" {
  type = string
}

variable "proxmox_user" {
  type      = string
  sensitive = true
}

variable "proxmox_password" {
  type      = string
  sensitive = true
}

variable "server_name" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "size" {
  type = string
  validation {
    condition     = can(regex("^(small|medium|large)$", var.size))
    error_message = "Must be small, medium or large"
  }
}

# Optional data disk
variable "data_disk_size_gb" {
  type    = number
  default = 0
}

variable "datastore_id" {
  type        = string
  description = "Datastore ID to create the VM disk on"
  default     = null
}

variable "source_qcow" {
  type = string
}