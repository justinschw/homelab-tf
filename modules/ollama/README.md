# Ollama Module

Terraform module for creating an LXC container on Proxmox configured to run Ollama with NVIDIA GPU access.

## Features

- Creates a privileged LXC container with GPU device passthrough
- Configures NVIDIA device nodes for GPU access
- Supports cloud-init for automated Ollama installation
- Follows the appliance module pattern with a parent module delegating to a container submodule

## Usage

```hcl
module "ollama" {
  source = "../../modules/ollama"

  vmid        = 112
  hostname    = "ollama"
  mgmt_bridge = "vmbr0"
  ip_address  = "192.168.1.150/24"
  gateway     = "192.168.1.1"

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
  - apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y nvidia-utils-525 || true
EOF
}
```

See `examples/ollama` for a complete working example.

## Requirements

- Proxmox host with NVIDIA GPU and drivers installed
- Ubuntu 25.04 LXC template (or adjust the `template` variable)
- Terraform with bpg/proxmox provider >= 1.0.0

## Variables

See `variables.tf` for the complete list of variables. Key variables:

- `vmid` - Proxmox VMID (required)
- `hostname` - Container hostname (required)
- `mgmt_bridge` - Network bridge (required)
- `ip_address` - IP address in CIDR format (required)
- `template` - LXC template (default: ubuntu-25.04-standard_25.04-1.1_amd64.tar.zst)
- `cores` - CPU cores (default: 4)
- `memory` - Memory in MB (default: 8192)
- `cloud_init_user_data` - Cloud-init user-data for bootstrapping

## Outputs

- `vmid` - VMID of the created container
- `hostname` - Hostname of the container
- `ip_address` - Configured IP address

## Security Considerations

This module creates a **privileged container** with host device access. This reduces isolation compared to unprivileged containers:

- Only use on trusted hosts
- Limit network exposure
- Consider the security implications before deploying in production
- See `container/README.md` for detailed security information

## GPU Setup

The container needs NVIDIA user-space libraries installed to use the GPU:

1. The host must have NVIDIA drivers installed
2. Inside the container, install matching nvidia-utils or CUDA runtime
3. Verify with `nvidia-smi` inside the container

See the example for a cloud-init configuration that automates this setup.
