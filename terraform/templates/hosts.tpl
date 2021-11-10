[masters]
%{ for ip in masters ~}
${ip}
%{ endfor ~}