#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
domain=
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./auto-install.sh [OPTIONS]"
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

## install docker
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf -y install dnf-plugins-core"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y docker-ce docker-ce-cli containerd.io"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable docker"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl start docker"
