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

## set timezone ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "timedatectl set-timezone Asia/Shanghai"

## update selinux config ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setenforce permissive"
scp -P "$remote_port" -i $ssh_key ./selinux/config "$remote_user"@"$remote_host":/etc/selinux/

## install mysql ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y mysql-community-server"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=3306/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 3306"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable mysqld"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart mysqld"
