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

## cuda toolkit ##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dpkg -i cuda-keyring_1.1-1_all.deb"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt -y install cuda-toolkit-12-6"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "reboot"

## install conda
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "bash Anaconda3-2024.10-1-Linux-x86_64.sh"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "/root/anaconda3/bin/conda init"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "conda create --name ktransformers python=3.11"
scp -P "$remote_port" -i $ssh_key ./profile.d/ktransformers.sh "$remote_user"@"$remote_host":/etc/profile.d/
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /etc/profile && strings ~/anaconda3/envs/ktransformers/lib/libstdc++.so.6 | grep GLIBCXX"

##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "conda activate ktransformers && pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "pip3 install packaging ninja cpufeature numpy flash-attn"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" ""
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" ""
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" ""
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" ""
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" ""


## upload profile.d
#scp -P "$remote_port" -i $ssh_key ./profile.d/ktransformers.sh "$remote_user"@"$remote_host":/etc/profile.d/
