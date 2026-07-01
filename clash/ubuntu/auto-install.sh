#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key="${HOME}/.ssh/id_rsa"
clash_subscribe="https://s-dywrwizazu.cn-shanghai.fcapp.run/okz/sub?token=7683b0dfce849a444dd77d66575e4556"

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

## install nginx
run "\
  apt install -y nginx \
  && rm -f /etc/nginx/sites-enabled/default \
"
put ./config/nginx/clash.nginx.http.conf /etc/nginx/conf.d/
run "systemctl restart nginx"

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

## set proxy
put ./proxy.sh /etc/profile.d/
