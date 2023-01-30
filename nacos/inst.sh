#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./inst.sh [OPTIONS]"
  echo "Options:"
  echo "  -h <ssh host>"
  echo "  -p <ssh port>"
  echo "  -u <ssh user>"
  exit;
}

while getopts "h:p:u:" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    ? ) showHelp ;;
  esac
done

## install nacos ##
## install nacos online ##
#ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "cd /root && wget https://github.com/alibaba/nacos/releases/download/2.1.1/nacos-server-2.1.1.zip && unzip nacos-server-2.1.1.zip"
## install nacos local ##
scp -P "$remote_port" -i ${ssh_key} ./nacos-server-2.1.1.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "rm -rf /root/nacos && cd /root && unzip -o nacos-server-2.1.1.zip"

## firewall
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 8848"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --add-port=8848/tcp --zone=public --permanent"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 9848"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --add-port=9848/tcp --zone=public --permanent"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 9849"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --add-port=9849/tcp --zone=public --permanent"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --reload"

## upload config ##
scp -P "$remote_port" -i ${ssh_key} ./application.properties "$remote_user"@"$remote_host":/root/nacos/conf/
scp -P "$remote_port" -i ${ssh_key} ./nacos.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/

## add nacos service ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl enable nacos"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl restart nacos"
