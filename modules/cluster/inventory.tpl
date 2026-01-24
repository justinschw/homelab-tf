[masters]
${master.server_name} ansible_host=${master.server_name}.${domain} ansible_user=${var.username}
[workers]
%{ for w in worker.value ~}
${w.server_name} ansible_host=${w.server_name}.${domain} ansible_user=${var.username}
%{ endfor ~}
