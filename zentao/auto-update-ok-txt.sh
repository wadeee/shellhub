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

## add ok.txt
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /opt/zbox/app/htdocs/ok.txt"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "touch /opt/zbox/app/htdocs/ok.txt"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /opt/zbox/app/zentao/www/data/ok.txt"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "touch /opt/zbox/app/zentao/www/data/ok.txt"
