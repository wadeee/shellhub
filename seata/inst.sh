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

## install seata ##
## install seata online ##
#ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "cd /root && wget https://github.com/seata/seata/releases/download/v1.5.2/seata-server-1.5.2.zip && unzip seata-server-1.5.2.zip"
## install seata local ##
scp -P "$remote_port" -i ${ssh_key} ./seata-server-1.5.2.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "rm -rf /root/seata && cd /root && unzip -o seata-server-1.5.2.zip"

## firewall
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 7091"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --add-port=7091/tcp --zone=public --permanent"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 8091"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --add-port=8091/tcp --zone=public --permanent"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --reload"

## add nacos config ## ## only first time need to run ##
#scp -P "$remote_port" -i ${ssh_key} ./config.txt "$remote_user"@"$remote_host":/root/seata/
#scp -P "$remote_port" -i ${ssh_key} ./nacos-config.sh "$remote_user"@"$remote_host":/root/seata/conf/
#ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "cd /root/seata/conf/ && sh nacos-config.sh localhost"

## upload config ##
scp -P "$remote_port" -i ${ssh_key} ./application.yml "$remote_user"@"$remote_host":/root/seata/conf/
scp -P "$remote_port" -i ${ssh_key} ./seata.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/

## add seata service ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl enable seata"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl restart seata"
