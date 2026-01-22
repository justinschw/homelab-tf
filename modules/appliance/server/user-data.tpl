#cloud-config
hostname: ${hostname}
fqdn: ${hostname}.${domain}
manage_etc_hosts: true

# Force early hostname setting
runcmd:
  - hostnamectl set-hostname ${hostname}
  - systemctl restart systemd-hostnamed

users:
  - name: ${username}
    ssh_authorized_keys:
%{ for key in ssh_keys ~}
      - ${key}
%{ endfor ~}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash