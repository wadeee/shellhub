#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./auto-install.sh [OPTIONS]"
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

## add proxy
scp -P "$remote_port" -i $ssh_key ./proxy.sh "$remote_user"@"$remote_host":/etc/profile.d/

## apt update
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git ffmpeg vim curl"

#bash /home/cellxserver/NVIDIA-Linux-x86_64-535.161.07-grid.run
#reboot
