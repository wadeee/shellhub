#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa
clash_subscribe="http://172.105.209.249:8570/link/OnazBn0SUlTajZ4z?clash=1"

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

## install clash
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -o /root/clash/clash_config.yaml $clash_subscribe"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/clash/conf"
scp -P "$remote_port" -i $ssh_key ./config.yaml "$remote_user"@"$remote_host":/root/clash/conf/
scp -P "$remote_port" -i $ssh_key ./Country.mmdb "$remote_user"@"$remote_host":/root/clash/conf/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sed -n '/^proxies:/,\$p' /root/clash/clash_config.yaml >> /root/clash/conf/config.yaml"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart clash"
