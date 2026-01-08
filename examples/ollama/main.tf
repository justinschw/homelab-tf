module "ollama" {
  source = "../../modules/ollama"

  vmid        = 112
  hostname    = "ollama"
  node_name   = "pve"
  mgmt_bridge = "vmbr0"
  ip_address  = "192.168.1.150/24"
  gateway     = "192.168.1.1"
  nameserver  = "1.1.1.1"

  storage     = "local-lvm"
  rootfs_size = "40G"

  cores  = 4
  memory = 8192

  cloud_init = true
  cloud_init_user_data = <<EOF
#cloud-config
package_update: true
packages:
  - curl
  - ca-certificates
runcmd:
  - curl -sSfL https://ollama.ai/install.sh | sh
  # also install the minimal nvidia runtime or CUDA packages inside the container
  - apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nvidia-utils-525 || true
EOF
}
