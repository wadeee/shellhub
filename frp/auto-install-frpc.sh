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

## install frp
scp -P "$remote_port" -i $ssh_key ./frp_0.65.0_linux_amd64.tar.gz "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "tar -zxvf frp_0.65.0_linux_amd64.tar.gz"
scp -P "$remote_port" -i $ssh_key ./frpc.yaml "$remote_user"@"$remote_host":/root/frp_0.65.0_linux_amd64/
scp -P "$remote_port" -i $ssh_key ./frpc.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/

## frpc restart ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable frpc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart frpc"
