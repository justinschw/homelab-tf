# Provider auth
variable "proxmox_endpoint" {
    type = string
}

variable "proxmox_api_token" {
    type = string
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "template_filename" {
  description = "Name of the template file to download"
  type        = string
  default     = "local:vztmpl/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
}

variable "template_url" {
  description = "URL of the template file to download"
  type        = string
  default     = "http://download.proxmox.com/images/system/ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst"
}
