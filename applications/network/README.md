## Homelab Terraform Definition
This is where I will define everything for my homelab, so that I can just press the button and it comes up. And my VMs can be cattle instead of pets.

## Before beginning
We first need to set up proxmox and associated hardware so we know what variables to use. When installing proxmox:
* Configure proxmox for a management connection. Populate the `proxmox_endpoint` variable appropriately in terraform.tfvars.
* Name the node. Save this name in the `proxmox_node_name` variable in terraform.tfvars.
* Make note of the port you want to use for egress (e.g. `eno1`). Save this as `proxmox_egress_port` in terraform.tfvars.
* Do the same with the management port and put it in `proxmox_mgmt_port` in terraform.tfvars.

After installing proxmox:
* Create an administrative user. You have to do this from the linux shell, then create corresponding user in the "Datacenter" section of the UI
* Give the user admin permissions. Go to `Datacenter > Permissions`, then `Add > User Permission`, Path=/, User=(your user), Role=Adminstrator
* Create an API Token for the new user. Go to `Datacenter > Permissions > API Tokens` and create one. Populate the `proxmox_api_token` variable appropriately in terraform.tfvars.

TODO: Add stuff for specific VMs, like with port names in pfsense, or PCI card IDs for NAS and OpenWRT
