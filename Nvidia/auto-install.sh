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

## upload
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /etc/nvidia/ClientConfigToken"
scp -P "$remote_port" -i $ssh_key ./blacklist-nouveau.conf "$remote_user"@"$remote_host":/etc/modprobe.d/
scp -P "$remote_port" -i $ssh_key ./client_configuration_token_13-08-2024-09_44_16.tok "$remote_user"@"$remote_host":/etc/nvidia/ClientConfigToken/
scp -P "$remote_port" -i $ssh_key ./NVIDIA-Linux-x86_64-535.161.07-grid.run "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "chmod +x /root/NVIDIA-Linux-x86_64-535.161.07-grid.run"

## run shell
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dracut --force"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl isolate multi-user.target"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y kernel-devel kernel-headers gcc make"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y kernel-devel-\$(uname -r)"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y kernel-headers-\$(uname -r)"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y pkg-config"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y libglvnd-devel"

# bash /root/NVIDIA-Linux-x86_64-535.161.07-grid.run
# systemctl isolate graphical.target
# reboot
