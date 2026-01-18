terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.70.0"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure = true
}

# Get Ubuntu 25.04 LXC template
resource "proxmox_virtual_environment_download_file" "lxc_template" {
  node_name    = "nexus"
  datastore_id = "local"

  content_type = "vztmpl"
  file_name    = var.template_filename

  url = var.template_url

  overwrite = true
}
