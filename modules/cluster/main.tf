terraform {
  backend "s3" {}
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = "3.13.1"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.70.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${var.proxmox_endpoint}"
  api_token = "${var.proxmox_api_user}=${var.proxmox_api_token}"
  insecure  = true
  ssh {
    agent    = false
    username = var.proxmox_user
    password = var.proxmox_password
  }
}

provider "minio" {
  minio_server   = var.minio_endpoint
  minio_user     = var.minio_access_key
  minio_password = var.minio_secret_key
  minio_region   = var.minio_region
  minio_ssl      = var.minio_use_ssl
  minio_insecure = var.minio_skip_verify
}

# Private cluster network
resource "proxmox_virtual_environment_network_linux_bridge" "cluster_network" {
  node_name = var.proxmox_node_name
  name      = var.cluster_network_bridge
  comment   = "Cluster private network for ${var.cluster_name}"
  autostart = true
  address   = var.cluster_network_cidr
}

module "master" {
  source = "../appliance/server"
  providers = {
    proxmox = proxmox
  }
  proxmox_endpoint  = var.proxmox_endpoint
  proxmox_api_user  = var.proxmox_api_user
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user      = var.proxmox_user
  proxmox_password  = var.proxmox_password
  server_name       = "${var.cluster_name}-master"
  vm_id             = var.master_vm_id
  size              = "medium"
  datastore_id      = var.datastore_id
  ssh_public_keys   = var.ssh_public_keys
  networks = concat(var.networks, [{
    bridge  = var.cluster_network_bridge,
    address = "${cidrhost(var.cluster_network_cidr, 10)}/${split("/", var.cluster_network_cidr)[1]}"
  }])
  source_vm_id        = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username            = var.username
}

module "worker_pool" {
  for_each = { for idx, id in var.worker_vm_ids : idx => id }
  source   = "../appliance/server"
  providers = {
    proxmox = proxmox
  }
  proxmox_endpoint  = var.proxmox_endpoint
  proxmox_api_user  = var.proxmox_api_user
  proxmox_api_token = var.proxmox_api_token
  proxmox_node_name = var.proxmox_node_name
  proxmox_user      = var.proxmox_user
  proxmox_password  = var.proxmox_password
  server_name       = "${var.cluster_name}-worker-${each.key}"
  vm_id             = each.value
  size              = "small"
  datastore_id      = var.datastore_id
  ssh_public_keys   = var.ssh_public_keys
  networks = concat(var.networks, [{
    bridge  = var.cluster_network_bridge,
    address = "${cidrhost(var.cluster_network_cidr, 20 + each.key)}/${split("/", var.cluster_network_cidr)[1]}"
  }])
  source_vm_id        = var.source_vm_id
  source_vm_datastore = var.source_vm_datastore
  username            = var.username
}

resource "minio_s3_bucket" "clusterinfo" {
  bucket = var.bucket_name
}

resource "minio_s3_object" "ansible_inventory" {
  depends_on  = [minio_s3_bucket.clusterinfo]
  bucket_name = minio_s3_bucket.clusterinfo.bucket
  object_name = "${var.cluster_name}/ansible/ansible-inventory.ini"
  content = templatefile("${path.module}/inventory.tpl", {
    master   = module.master
    domain   = var.domain_name
    username = var.username
    worker = [
      for _, v in module.worker_pool : {
        server_name = v.server_name
      }
    ]
  })
  content_type = "text/plain"
}

resource "minio_s3_object" "ansible_vars" {
  depends_on  = [minio_s3_bucket.clusterinfo]
  bucket_name = minio_s3_bucket.clusterinfo.bucket
  object_name = "${var.cluster_name}/ansible/ansible-vars.yml"
  content = templatefile("${path.module}/vars.tpl", {
    master      = module.master
    domain_name = var.domain_name
  })
  content_type = "text/plain"
}
