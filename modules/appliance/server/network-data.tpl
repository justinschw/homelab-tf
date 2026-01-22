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
    %{endif ~}
    gateway4: ${network.gateway}
    dhcp6: false
%{ endfor ~}