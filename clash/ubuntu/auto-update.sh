#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key="${HOME}/.ssh/id_rsa"
clash_subscribe="http://47.107.66.153:65533/api/v1/12/25?token=1a8716f6dfe0a992e53fb561f3197e38"

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

## update clash
run "\
  curl -o /root/clash/clash_config.yaml $clash_subscribe \
  && mkdir -p /root/clash/conf \
"
put ./config.yaml /root/clash/conf/
put ./Country.mmdb /root/clash/conf/
run "\
  sed -n '/^proxies:/,\$p' /root/clash/clash_config.yaml >> /root/clash/conf/config.yaml \
  && systemctl restart clash \
"
