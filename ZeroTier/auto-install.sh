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

## install
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -s https://install.zerotier.com | bash"

## upload
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /var/lib/zerotier-one/moons.d"
scp -P "$remote_port" -i $ssh_key ./000000ec93aa2db6.moon "$remote_user"@"$remote_host":/var/lib/zerotier-one/moons.d/
scp -P "$remote_port" -i $ssh_key ./planet "$remote_user"@"$remote_host":/var/lib/zerotier-one/

## restart zerotier-one
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart zerotier-one.service"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "zerotier-cli peers"

# zerotier-cli join ec93aa2db627887d
# zerotier-cli peers
