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

## download jar ##
# ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "mkdir /root/jars && cd /root/jars && wget https://github.com/alibaba/Sentinel/releases/download/1.8.6/sentinel-dashboard-1.8.6.jar"
## upload jar ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "mkdir /root/jars"
scp -P "$remote_port" -i ${ssh_key} ./sentinel-dashboard-1.8.6.jar "$remote_user"@"$remote_host":/root/jars/

## firewall
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 8718"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --add-port=8718/tcp --zone=public --permanent"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "firewall-cmd --reload"

## upload config ##
scp -P "$remote_port" -i ${ssh_key} ./sentinel.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/

## add sentinel service ##
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl enable sentinel"
ssh -p "$remote_port" -i ${ssh_key} "$remote_user"@"$remote_host" "systemctl restart sentinel"
