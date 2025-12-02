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

## install nginx
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install -y nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /etc/nginx/sites-enabled/default"
scp -P "$remote_port" -i $ssh_key ./config/nginx/clash.nginx.http.conf "$remote_user"@"$remote_host":/etc/nginx/conf.d/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart nginx"

## install clash
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /root/clash/clash-linux-amd64"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/clash/"
scp -P "$remote_port" -i $ssh_key ./clash-linux-amd64 "$remote_user"@"$remote_host":/root/clash/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "chmod +x /root/clash/clash-linux-amd64"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -o /root/clash/clash_config.yaml $clash_subscribe"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/clash/conf"
scp -P "$remote_port" -i $ssh_key ./config.yaml "$remote_user"@"$remote_host":/root/clash/conf/
scp -P "$remote_port" -i $ssh_key ./Country.mmdb "$remote_user"@"$remote_host":/root/clash/conf/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sed -n '/^proxies:/,\$p' /root/clash/clash_config.yaml >> /root/clash/conf/config.yaml"
scp -P "$remote_port" -i $ssh_key ./config/systemd/clash.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable clash"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart clash"

## install clash board ui
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/zips"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /usr/share/clash-board-ui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /usr/share/clash-board-ui/"
scp -P "$remote_port" -i $ssh_key ./clash-board-ui.tar.xz "$remote_user"@"$remote_host":/root/zips/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "tar -xJf /root/zips/clash-board-ui.tar.xz -C /usr/share/clash-board-ui"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mv /usr/share/clash-board-ui/public/* /usr/share/clash-board-ui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /usr/share/clash-board-ui/public"

## remove proxy temp
scp -P "$remote_port" -i $ssh_key ./proxy.sh "$remote_user"@"$remote_host":/etc/profile.d/
