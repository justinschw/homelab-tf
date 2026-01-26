# Proxmox info
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

# Minio info

variable "minio_endpoint" {
  type = string
}

variable "minio_access_key" {
  type      = string
  sensitive = true
}

variable "minio_secret_key" {
  type      = string
  sensitive = true
}

variable "minio_region" {
  type    = string
  default = "main"
}

variable "bucket_name" {
  type = string
}

variable "minio_use_ssl" {
  type    = bool
  default = false
}

variable "minio_skip_verify" {
  type    = bool
  default = true
}

# VM info

variable "datastore_id" {
  type = string
}

variable "ssh_public_keys" {
  type    = list(string)
  default = []
}

variable "networks" {
  description = "List of network objects with fields `bridge` and `address` (e.g. address can be 'dhcp' or CIDR)."
  type = list(object({
    bridge  = string
    address = string
    gateway = optional(string)
  }))
  default = [{
    bridge  = "vmbr0"
    address = "dhcp"
  }]
}

variable "domain_name" {
  type    = string
  default = "homelab.io"
}

variable "source_vm_id" {
  description = "When non-zero, clone from this source VM ID"
  type        = number
  default     = 0
}

variable "source_vm_datastore" {
  description = "Datastore of the source VM to clone from"
  type        = string
  default     = ""
}

variable "username" {
  type    = string
  default = "k3s"
}

# Cluster info

variable "cluster_name" {
  type = string
}

variable "master_vm_id" {
  type    = number
  default = 0
}

variable "worker_vm_ids" {
  type    = list(number)
  default = []
}

variable "cluster_network_bridge" {
  type = string
}

variable "cluster_network_cidr" {
  type    = string
  default = "192.168.1.0/24"
}
