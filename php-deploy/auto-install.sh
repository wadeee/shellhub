#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./auto-install.sh [OPTIONS]"
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

## install git ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y git"

## install php
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y epel-release"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y https://rpms.remirepo.net/enterprise/remi-release-9.rpm"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y php php-cli php-fpm php-mysqlnd php-gd php-mbstring php-xml php-opcache php-json php-zip"

## install nginx
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl start nginx"
