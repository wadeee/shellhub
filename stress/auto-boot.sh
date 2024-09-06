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

## template
# lscpu
# nproc
scp -P "$remote_port" -i $ssh_key ./stress.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
scp -P "$remote_port" -i $ssh_key ./crontab "$remote_user"@"$remote_host":/etc/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart crond"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl start stress"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "nohup stress --cpu 6 > /dev/null 2>&1 &"
