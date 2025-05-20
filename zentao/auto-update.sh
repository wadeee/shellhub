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

## backup
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl stop zbox"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd /opt/zbox && zip -r /root/zbox-bak.zip ./*"

## upload zentao
scp -P "$remote_port" -i $ssh_key ./ZenTaoPMS-21.7-php7.2_7.4.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /root/zentaopms"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "unzip -o /root/ZenTaoPMS-21.7-php7.2_7.4.zip -d /root/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cp -rf /root/zentaopms/* /opt/zbox/app/zentao/"

## service
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable zbox"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart zbox"

## http://localhost/zentao/upgrade.php
