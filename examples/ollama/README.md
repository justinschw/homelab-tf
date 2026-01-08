# Ollama LXC Container Example

This example shows how to create an Ollama container using the `modules/ollama` module.

## Configuration

The example creates a privileged LXC container configured with:
- NVIDIA GPU device access
- 4 CPU cores
- 8GB RAM
- 40GB root filesystem

## Cloud-Init

The cloud-init user-data attempts to:
1. Install Ollama using the upstream install script from https://ollama.ai/install.sh
2. Install nvidia-utils package (example version 525, adjust to match your environment)

## Important Notes

- **Adjust the nvidia-utils package version** to match your host's NVIDIA driver version
- The container must be privileged to access GPU devices
- Ensure your Proxmox host has NVIDIA drivers installed
- The example IP address and network configuration should be adjusted for your environment
- **Manual configuration required**: After the container is created, you may need to manually edit `/etc/pve/lxc/<vmid>.conf` on the Proxmox host to add LXC device and mount configurations. See the module README for details.

## Usage

```bash
terraform init
terraform plan
terraform apply
```

After the container is created and cloud-init completes, you may need to:
1. Edit `/etc/pve/lxc/112.conf` on the Proxmox host to add GPU device configuration (see module README)
2. Restart the container: `pct stop 112 && pct start 112`
3. Access the container: `ssh root@192.168.1.150` (or via Proxmox console)
4. Verify GPU access: `nvidia-smi`
5. Test Ollama: `ollama run llama2`
