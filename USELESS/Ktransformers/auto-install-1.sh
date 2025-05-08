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

## nouveau ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /etc/modprobe.d/"
scp -P "$remote_port" -i $ssh_key ./modprobe.d/blacklist-nouveau.conf "$remote_user"@"$remote_host":/etc/modprobe.d/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "update-initramfs -u"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "reboot"

# /root/NVIDIA-Linux-x86_64-535.161.07-grid.run
# reboot