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

## focus to current dir
CURRENT_DIR="$(realpath "$(dirname "$0")")"
cd "$CURRENT_DIR" || exit

## upload SQL
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/sql/"
scp -P "$remote_port" -i $ssh_key ./sql/sesintec_pages.sql "$remote_user"@"$remote_host":/root/sql/sesintec_pages.sql

## create database
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mysql -uroot -ppassword -e \"create schema sesintec_pages;\""
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mysql -uroot -ppassword -Dsesintec_pages < /root/sql/sesintec_pages.sql"
