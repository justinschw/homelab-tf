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
  default     = "local:vztmpl/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
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
  default     = null
}

variable "nameserver" {
  description = "DNS nameserver"
  type        = string
  default     = "8.8.8.8"
}

variable "searchdomain" {
  description = "Search domain"
  type        = string
  default     = ""
}

variable "storage" {
  description = "Storage name for rootfs (e.g. local-lvm)"
  type        = string
  default     = "local"
}

variable "rootfs_size" {
  description = "Rootfs size like 32G"
  type        = string
  default     = "32G"
}

variable "cores" {
  description = "CPU cores"
  type        = number
  default     = 4
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 8192
}

variable "swap" {
  description = "Swap in MB"
  type        = number
  default     = 0
}

variable "root_password" {
  description = "Root password (sensitive)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_authorized_keys" {
  description = "SSH public keys"
  type        = string
  default     = ""
}

variable "cloud_init" {
  description = "Enable cloud-init for the container (if template supports it)"
  type        = bool
  default     = false
}

variable "cloud_init_user_data" {
  description = "cloud-init user-data content"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Optional list of tags"
  type        = list(string)
  default     = []
}
