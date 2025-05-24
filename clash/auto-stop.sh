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

## stop proxy
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /etc/profile.d/proxy.sh"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl disable clash"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl stop clash"
