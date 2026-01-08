# ollama/container

Container submodule for creating an LXC configured to run Ollama with access to an NVIDIA GPU.

## Notes, Caveats and How-To

### Privileged Container
- The container is created as privileged (`unprivileged = false`) so it can access host character devices. This increases risk; only run on trusted hosts.
- Privileged containers that expose host devices are less isolated than unprivileged containers. Limit network exposure and only use on trusted networks.

### GPU Requirements
- **Host must have NVIDIA drivers installed and working.**
- The container still needs NVIDIA user-space libraries (CUDA runtime or at least libcuda). Install inside the container via apt or the NVIDIA package repositories, or bind-mount host libraries (not recommended unless you know the ABI compatibility).
- Cloud-init can be used to bootstrap installation of Ollama and NVIDIA runtime. See `examples/ollama` for a sample minimal user-data.

### GPU Device Details
- The module attempts to pass through common NVIDIA device nodes to the container using `device_passthrough`.
- **Important**: The bpg/proxmox provider's `device_passthrough` may not fully support all LXC device configurations. You may need to manually edit `/etc/pve/lxc/<vmid>.conf` on your Proxmox host to add:
  ```
  lxc.cgroup.devices.allow = c 195:* rwm
  lxc.cgroup.devices.allow = c 243:* rwm  
  lxc.cgroup.devices.allow = c 254:* rwm
  lxc.mount.entry = /dev/nvidia0 dev/nvidia0 none bind,optional,create=file 0 0
  lxc.mount.entry = /dev/nvidiactl dev/nvidiactl none bind,optional,create=file 0 0
  lxc.mount.entry = /dev/nvidia-uvm dev/nvidia-uvm none bind,optional,create=file 0 0
  lxc.mount.entry = /dev/nvidia-modeset dev/nvidia-modeset none bind,optional,create=file 0 0
  lxc.mount.entry = /dev/dri dev/dri none bind,optional,create=dir 0 0
  ```
- On some systems device major/minor numbers can differ. If devices are missing, check host `/dev` and adapt the configuration accordingly.
- After adding manual configuration, restart the container for changes to take effect.

### Security Considerations
- Privileged containers have more access to the host system than unprivileged containers
- Device passthrough further reduces isolation
- Only use this configuration on trusted hosts and networks
- Consider the security implications before deploying in production

## Usage

See the parent module `modules/ollama` for the main interface, or check `examples/ollama` for a complete example.
