version: 2
ethernets:
%{ for network in networks ~}
  ${network.bridge}:
    %{ if network.address == "dhcp" ~}
    dhcp4: true
    dhcp4-overrides:
      hostname: ${hostname}
    %{ else ~}
    dhcp4: false
    addresses:
      - ${network.address}
    gateway4: ${network.gateway}
    %{endif ~}
    dhcp6: false
%{ endfor ~}