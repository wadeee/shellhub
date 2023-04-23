#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa_cellx_base_temp

showHelp() {
  echo "Usage: sh ./auto-mysql-install.sh [OPTIONS]"
  echo "Options:"
  echo "  -h <ssh host>"
  echo "  -p <ssh port>"
  echo "  -u <ssh user>"
  exit;
}

while getopts "h:p:u:w:" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    ? ) showHelp ;;
  esac
done

## 生成key
ssh-keygen -m PEM -t rsa -N '' -f $ssh_key

## 登录服务器
ssh-copy-id -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host"

## upload SQL
scp -P "$remote_port" -i ${ssh_key} ./gogs_0.13.0_linux_amd64.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "rm -rf /root/gogs && cd /root && unzip -o gogs_0.13.0_linux_amd64.zip"

## create database
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mysql -uroot -e \"alter user user() identified by 'password'; use mysql; update user set host='%' where user ='root'; flush privileges;\""
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mysql -uroot -ppassword -e \"create schema gogs;\""
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mysql -uroot -ppassword < /root/gogs/scripts/mysql.sql"

## remove ssh_key
rm -f $ssh_key
rm -f $ssh_key.pub
