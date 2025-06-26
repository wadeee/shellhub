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

while getopts "h:p:u:w:" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    ? ) showHelp ;;
  esac
done

## create database
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mysql -uroot -ppassword -e \"create schema nacos;\""
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mysql -uroot -ppassword -Dnacos < /root/nacos/conf/mysql-schema.sql"
