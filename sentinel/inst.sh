#!/bin/sh

remote_host="$1"
remote_user="root"
remote_port=22
ssh_key=~/.ssh/id_rsa

## upload jar ##
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "mkdir /root/jars"
scp -P ${remote_port} -i ${ssh_key} ./sentinel-dashboard-1.8.5.jar ${remote_user}@"${remote_host}":/root/jars/

## firewall
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "setsebool -P httpd_can_network_connect 1"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "semanage port -a -t http_port_t -p tcp 8718"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "firewall-cmd --add-port=8718/tcp --zone=public --permanent"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "firewall-cmd --reload"

## upload config ##
scp -P ${remote_port} -i ${ssh_key} ./sentinel.service ${remote_user}@"${remote_host}":/usr/lib/systemd/system/

## add sentinel service ##
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "systemctl daemon-reload"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "systemctl enable sentinel"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "systemctl restart sentinel"
