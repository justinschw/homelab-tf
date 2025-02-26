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

resource "proxmox_virtual_environment_download_file" "latest_fedora_rawhide_qcow2_img" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.proxmox_node_name
  file_name    = var.server_target_file
  url          = var.server_download_file
}

output "cloud_image_id" {
  value = proxmox_virtual_environment_download_file.latest_fedora_rawhide_qcow2_img.id
}
