#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./auto-mysql-install.sh [OPTIONS]"
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

## focus to current dir
CURRENT_DIR="$(realpath "$(dirname "$0")")"
cd "$CURRENT_DIR" || exit

## set timezone ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "timedatectl set-timezone Asia/Shanghai"

## install
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y https://repo.mysql.com//mysql84-community-release-el9-2.noarch.rpm"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y mysql-community-server"

## open port 3306
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=3306/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --list-ports"

## enable and start server
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable mysqld"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl start mysqld"
