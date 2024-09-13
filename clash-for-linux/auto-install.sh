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

## add proxy temp
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /etc/profile.d/proxy.sh"
scp -P "$remote_port" -i $ssh_key ./proxy-temp.sh "$remote_user"@"$remote_host":/etc/profile.d/

## update selinux config ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setenforce permissive"
scp -P "$remote_port" -i $ssh_key ./config/selinux/config "$remote_user"@"$remote_host":/etc/selinux/

## install nginx
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl start nginx"
scp -P "$remote_port" -i $ssh_key ./config/nginx/nginx.conf "$remote_user"@"$remote_host":/etc/nginx/
scp -P "$remote_port" -i $ssh_key ./config/nginx/clash.nginx.http.conf "$remote_user"@"$remote_host":/etc/nginx/conf.d/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart nginx"

## firewall ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=80/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 80"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=7890/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 7890"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=7891/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 7891"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"

## install clash
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /root/clash/clash-linux-amd64"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/clash/"
scp -P "$remote_port" -i $ssh_key ./clash-linux-amd64 "$remote_user"@"$remote_host":/root/clash/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "chmod +x /root/clash/clash-linux-amd64"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -o /root/clash/clash_config.yaml https://knmvc.site/NBCMR/FJ9Bl/ch"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/clash/conf"
scp -P "$remote_port" -i $ssh_key ./config.yaml "$remote_user"@"$remote_host":/root/clash/conf/
scp -P "$remote_port" -i $ssh_key ./Country.mmdb "$remote_user"@"$remote_host":/root/clash/conf/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sed -n '/^proxies:/,\$p' /root/clash/clash_config.yaml >> /root/clash/conf/config.yaml"
scp -P "$remote_port" -i $ssh_key ./config/systemd/clash.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable clash"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart clash"

## install
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/zips"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /usr/share/clash-board-ui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /usr/share/clash-board-ui/"
scp -P "$remote_port" -i $ssh_key ./clash-board-ui.zip "$remote_user"@"$remote_host":/root/zips/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "unzip /root/zips/clash-board-ui.zip -d /usr/share/clash-board-ui"

## remove proxy temp
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /etc/profile.d/proxy-temp.sh"
scp -P "$remote_port" -i $ssh_key ./proxy.sh "$remote_user"@"$remote_host":/etc/profile.d/
