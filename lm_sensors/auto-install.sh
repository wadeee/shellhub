#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
domain=
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./inst.sh [OPTIONS]"
  echo "Options:"
  echo "  -h <ssh host>"
  echo "  -p <ssh port>"
  echo "  -u <ssh user>"
  echo "  -d <domain>"
  exit;
}

while getopts "h:p:u:d:" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    d ) domain=$OPTARG ;;
    ? ) showHelp ;;
  esac
done

## install lm_sensors
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y lm_sensors"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sensors-detect"

## get sensors
# sensors
