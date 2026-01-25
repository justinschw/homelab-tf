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

# Bitwarden info

variable "bitwarden_email" {
  type = string
}

variable "bitwarden_password" {
  type      = string
  sensitive = true
}

variable "bitwarden_client_id" {
  type      = string
  sensitive = true
}

variable "bitwarden_client_secret" {
  type      = string
  sensitive = true
}

# Firewall info (if needed)
variable "pfsense_config" {
  type = object({
    url             = string
    username        = optional(string, "admin")
    password        = string
    tls_skip_verify = optional(bool, true)
  })
  sensitive = true
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
  default = []
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

variable "vm_ids" {
  type    = list(number)
  default = []
}
