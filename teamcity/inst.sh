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

## install teamcity ##
## install teamcity online ##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://download.jetbrains.com.cn/teamcity/TeamCity-2022.10.2.tar.gz && tar zxf TeamCity-2022.10.2.tar.gz"
## install teamcity local ##
scp -P "$remote_port" -i $ssh_key ./TeamCity-2022.10.2.tar.gz "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /root/TeamCity && cd /root && tar zxf TeamCity-2022.10.2.tar.gz"

## firewall
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 8111"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=8111/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"

## upload config ##
scp -P "$remote_port" -i $ssh_key ./teamcity.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/

## add services ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable teamcity"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart teamcity"
