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
  rm -f /etc/profile.d/proxy.sh \
  && systemctl disable clash \
  && systemctl stop clash \
"
