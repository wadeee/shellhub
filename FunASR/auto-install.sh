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

## add proxy
scp -P "$remote_port" -i $ssh_key ./config/proxy.sh "$remote_user"@"$remote_host":/etc/profile.d/

## install conda
scp -P "$remote_port" -i $ssh_key ./Anaconda3-2025.06-1-Linux-x86_64.sh "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "bash Anaconda3-2025.06-1-Linux-x86_64.sh"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "/root/anaconda3/bin/conda init"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "/root/anaconda3/bin/conda create --name funasr python=3.11 -y"

## install
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
scp -P "$remote_port" -i $ssh_key ./libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dpkg -i libssl1.1_1.1.1f-1ubuntu2.24_amd64.deb"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install libssl-dev libcrypto++-dev ffmpeg -y"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /root/anaconda3/etc/profile.d/conda.sh && conda activate funasr && source /etc/profile.d/proxy.sh && proxy_on && pip install torch torchaudio humanfriendly"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /root/anaconda3/etc/profile.d/conda.sh && conda activate funasr && source /etc/profile.d/proxy.sh && proxy_on && pip install -U funasr"

## upload workspace
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install zip -y"
scp -P "$remote_port" -i $ssh_key ./workspace.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "unzip /root/workspace.zip -d /workspace"

## upload service
scp -P "$remote_port" -i $ssh_key ./funasr.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable funasr"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart funasr"
