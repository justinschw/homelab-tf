#cloud-config
preserve_hostname: false
hostname: ${hostname}
fqdn: ${hostname}.${domain}
manage_etc_hosts: true

users:
  - name: ${username}
    ssh_authorized_keys:
%{ for key in ssh_keys ~}
      - ${key}
%{ endfor ~}
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash