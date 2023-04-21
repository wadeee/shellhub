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

## firewall
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"

## install git ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "dnf install -y git"

## redis ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf -y install redis"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setenforce 0"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=6379/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable redis"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart redis"

## upload gogs ##
scp -P "$remote_port" -i ${ssh_key} ./gogs_0.13.0_linux_amd64.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "rm -rf /root/gogs && cd /root && unzip -o gogs_0.13.0_linux_amd64.zip"

## firewall ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=3000/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"

## upload config ##
scp -P "$remote_port" -i ${ssh_key} ./gogs.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/

## add gogs service ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl enable gogs"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl restart gogs"
