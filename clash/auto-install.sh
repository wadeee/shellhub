#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key="${HOME}/.ssh/id_rsa"
clash_subscribe="http://172.105.209.249:8570/link/OnazBn0SUlTajZ4z?clash=1"

showHelp() {
  echo "Usage: sh $0 [OPTIONS]"
  echo "Options:"
  echo "  -h <ssh host>"
  echo "  -p <ssh port>"
  echo "  -u <ssh user>"
  exit
}

while getopts "h:p:u:" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    ? ) showHelp ;;
  esac
done

[ -z "$remote_host" ] && showHelp

remote_target="$remote_user@$remote_host"

run() {
  ssh -p "$remote_port" -i "$ssh_key" "$remote_target" "$@"
}

put() {
  scp -P "$remote_port" -i "$ssh_key" "$1" "$remote_target":"$2"
}

## update selinux config
run "setenforce permissive"
put ./config/selinux/config /etc/selinux/

## install nginx
run "\
  dnf install -y nginx \
  && systemctl enable nginx \
  && systemctl start nginx \
"
put ./config/nginx/nginx.conf /etc/nginx/
put ./config/nginx/clash.nginx.http.conf /etc/nginx/conf.d/
run "systemctl restart nginx"

## firewall
run "\
  setsebool -P httpd_can_network_connect 1 \
  && firewall-cmd --add-port=80/tcp --zone=public --permanent \
  && semanage port -a -t http_port_t -p tcp 80 \
  && firewall-cmd --add-port=7890/tcp --zone=public --permanent \
  && semanage port -a -t http_port_t -p tcp 7890 \
  && firewall-cmd --add-port=7891/tcp --zone=public --permanent \
  && semanage port -a -t http_port_t -p tcp 7891 \
  && firewall-cmd --reload \
"

## install clash
run "\
  rm -f /root/clash/clash-linux-amd64 \
  && mkdir -p /root/clash/ \
"
put ./clash-linux-amd64 /root/clash/
run "\
  chmod +x /root/clash/clash-linux-amd64 \
  && curl -o /root/clash/clash_config.yaml $clash_subscribe \
  && mkdir -p /root/clash/conf \
"
put ./config.yaml /root/clash/conf/
put ./Country.mmdb /root/clash/conf/
run "sed -n '/^proxies:/,\$p' /root/clash/clash_config.yaml >> /root/clash/conf/config.yaml"
put ./config/systemd/clash.service /usr/lib/systemd/system/
run "\
  systemctl daemon-reload \
  && systemctl enable clash \
  && systemctl restart clash \
"

## install clash board ui
run "\
  mkdir -p /root/zips \
  && rm -rf /usr/share/clash-board-ui/ \
  && mkdir -p /usr/share/clash-board-ui/ \
"
put ./clash-board-ui.zip /root/zips/
run "unzip /root/zips/clash-board-ui.zip -d /usr/share/clash-board-ui"

## remove proxy temp
run "rm -f /etc/profile.d/proxy-temp.sh"
put ./proxy.sh /etc/profile.d/
