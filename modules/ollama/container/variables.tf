variable "vmid" {
  description = "Proxmox numeric VMID for the container"
  type        = number
}

variable "hostname" {
  description = "Hostname for the container"
  type        = string
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "template" {
  description = "Proxmox LXC template to use"
  type        = string
}

variable "mgmt_bridge" {
  description = "Management bridge (e.g. vmbr0)"
  type        = string
}

variable "ip_address" {
  description = "IP address (CIDR) to assign to the container"
  type        = string
}

variable "gateway" {
  description = "Gateway for the container network"
  type        = string
}

variable "nameserver" {
  description = "DNS nameserver"
  type        = string
}

variable "searchdomain" {
  description = "Search domain"
  type        = string
}

variable "storage" {
  description = "Storage name for rootfs"
  type        = string
}

variable "rootfs_size" {
  description = "Rootfs size"
  type        = string
}

variable "cores" {
  description = "CPU cores"
  type        = number
}

variable "memory" {
  description = "Memory in MB"
  type        = number
}

variable "swap" {
  description = "Swap in MB"
  type        = number
}

variable "root_password" {
  description = "Root password"
  type        = string
  sensitive   = true
}

variable "ssh_authorized_keys" {
  description = "SSH public keys"
  type        = string
}

variable "cloud_init" {
  description = "Enable cloud-init"
  type        = bool
}

variable "cloud_init_user_data" {
  description = "cloud-init user-data content"
  type        = string
}

variable "tags" {
  description = "List of tags"
  type        = list(string)
}
