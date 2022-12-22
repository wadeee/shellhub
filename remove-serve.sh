#!/bin/sh

service_name="namegeneratorsystem"
ssh_key=~/.ssh/id_rsa_cellx_base_temp
remote_host=
remote_user="root"
remote_port="22"

ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl stop $service_name"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl disable $service_name"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/lib/systemd/system/$service_name.service"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /root/jars/$service_name.jar"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /etc/nginx/conf.d/$service_name.ui.nginx.http.conf"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /usr/share/$service_name-ui/"

ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart nginx"
