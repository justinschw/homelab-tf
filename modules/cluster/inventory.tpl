[masters]
${master.server_name} ansible_host=${master.server_name}.${domain} ansible_user=${username}
[workers]
%{ for w in worker ~}
${w.server_name} ansible_host=${w.server_name}.${domain} ansible_user=${username}
%{ endfor ~}
