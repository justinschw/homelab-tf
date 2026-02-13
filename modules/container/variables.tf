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

# Container info
variable "cpus" {
  type        = number
  default     = 2
  description = "Number of CPUs for the container"
}

variable "memory" {
  type        = number
  default     = 8192
  description = "Memory in MB (default 8GB)"
}

variable "template" {
  type        = string
  description = "CT template to create the image from (e.g. local:vztmpl/ubuntu-20.04...)"
}

variable "type" {
  type        = string
  description = "Operating system type (e.g. ubuntu, debian, centos)"
}

variable "disk_size" {
  type        = number
  default     = 20
  description = "Disk size in GB (default 20)"
}

variable "ip_address" {
  type        = string
  default     = "dhcp"
  description = "IP address (CIDR) for the container, or 'dhcp' to use DHCP"
}

variable "vmid" {
  type        = number
  description = "VMID to assign to the container (must be unique)"
}

variable "hostname" {
  type        = string
  default     = ""
  description = "Hostname for the container (optional)"
}

variable "storage_pool" {
  type        = string
  default     = "local"
  description = "Proxmox storage pool to place the rootfs (e.g. local, local-lvm)"
}

variable "net_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Bridge to attach the container network to"
}

variable "ssh_public_keys" {
  type    = list(string)
  default = []
}

variable "node" {
  type        = string
  default     = "pve"
  description = "Proxmox node name"
}

variable "password" {
  type        = string
  default     = ""
  description = "Root password for the container (optional)"
}
