[web]
${web_public_ip} ansible_user=${ssh_user} ansible_ssh_private_key_file=${ssh_private_key}

[app]
${app_private_ip} ansible_user=${ssh_user} ansible_ssh_private_key_file=${ssh_private_key} ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ProxyCommand="ssh -i ${ssh_private_key} -W %h:%p ${ssh_user}@${web_public_ip}"'

[all:vars]
db_endpoint = "${db_endpoint}"
db_user = "${db_user}"
db_pass = "${db_pass}"
db_name = "${db_name}"
app_private_ip = "${app_private_ip_for_web_conf}"
