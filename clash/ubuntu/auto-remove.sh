#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key="${HOME}/.ssh/id_rsa"

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

## stop proxy
run "\
  systemctl stop clash \
  && systemctl disable clash \
  && rm -rf /usr/lib/systemd/system/clash.service \
  && systemctl daemon-reload \
  && rm -f /etc/profile.d/proxy.sh \
  && rm -rf /root/zips/clash-board-ui.zip \
  && rm -rf /usr/share/clash-board-ui \
  && rm -rf /root/clash/
"

## stop nginx
run "\
  systemctl stop nginx \
  && systemctl disable nginx \
  && apt purge -y 'nginx*' \
  && sudo apt autoremove -y \
  && sudo apt autoclean \
  && sudo rm -rf /etc/nginx /var/log/nginx /var/cache/nginx /usr/share/nginx
"