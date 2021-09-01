#!/bin/sh

service_name="namegeneratorsystem"
ssh_key="C:/Users/TS/.ssh/id_rsa_ssh8"
remote_user="root"
remote_host="office.cellx.com.cn"
remote_port=36010

## remove backend
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@${remote_host} "rm -f /usr/lib/systemd/system/${service_name}.service"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@${remote_host} "rm -f /etc/nginx/conf.d/${service_name}.nginx.http.conf"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@${remote_host} "rm -f /root/jars/${service_name}.jar"

## remove frontend
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@${remote_host} "rm -f /etc/nginx/conf.d/${service_name}.ui.nginx.http.conf"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@${remote_host} "rm -rf /usr/share/${service_name}-ui/"

ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@${remote_host} "systemctl daemon-reload"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@${remote_host} "systemctl restart nginx"
