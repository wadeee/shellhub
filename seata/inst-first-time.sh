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

## add nacos config ## ## only first time need to run ##
scp -P "$remote_port" -i ${ssh_key} ./config.txt "$remote_user"@"$remote_host":/root/seata/
scp -P "$remote_port" -i ${ssh_key} ./nacos-config.sh "$remote_user"@"$remote_host":/root/seata/conf/
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "cd /root/seata/conf/ && sh nacos-config.sh 127.0.0.1"
