module "container" {
  source = "./container"

  vmid                 = var.vmid
  hostname             = var.hostname
  node_name            = var.node_name
  template             = var.template
  mgmt_bridge          = var.mgmt_bridge
  ip_address           = var.ip_address
  gateway              = var.gateway
  nameserver           = var.nameserver
  searchdomain         = var.searchdomain
  storage              = var.storage
  rootfs_size          = var.rootfs_size
  cores                = var.cores
  memory               = var.memory
  swap                 = var.swap
  root_password        = var.root_password
  ssh_authorized_keys  = var.ssh_authorized_keys
  cloud_init           = var.cloud_init
  cloud_init_user_data = var.cloud_init_user_data
  tags                 = var.tags
}
