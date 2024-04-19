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

## install arths ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir /root/jars/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -o /root/jars/arthas-boot.jar https://arthas.aliyun.com/arthas-boot.jar"
