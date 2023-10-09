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

## set timezone ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "timedatectl set-timezone Asia/Shanghai"

## update mirror urls ##
#ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "sed -i -e 's|mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*"
#ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "sed -i -e 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*"

## install mysql ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "dnf -y install @mysql"
## install mysql on CentOS9 ##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf -y install https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf -y install mysql-community-server"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "grep 'A temporary password is generated' /var/log/mysqld.log | tail -1"

## enable and start server ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl enable mysqld"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl start mysqld"

## open port 3306
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --add-port=3306/tcp --zone=public --permanent"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --reload"
