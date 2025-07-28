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

## set timezone ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "timedatectl set-timezone Asia/Shanghai"

## apt update
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git ffmpeg vim curl"

## cuda toolkit ##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dpkg -i cuda-keyring_1.1-1_all.deb"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt -y install cuda-toolkit-12-6"

## download ollama
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /etc/profile.d/proxy.sh && proxy_on && curl -fsSL https://ollama.com/install.sh | sh"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ollama pull qwen2.5:14b"

## reboot
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "reboot"

## bash /home/cellxserver/NVIDIA-Linux-x86_64-535.161.07-grid.run --uninstall
## reboot
## bash /home/cellxserver/NVIDIA-Linux-x86_64-535.161.07-grid.run
## reboot
