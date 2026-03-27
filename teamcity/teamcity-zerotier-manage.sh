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

## join
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "zerotier-cli join ec93aa2db627887d" ## GZCN
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "zerotier-cli join ec93aa2db6977845" ## QHYB

## settings only one allowManaged=1
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "zerotier-cli set ec93aa2db627887d allowManaged=0" ## GZCN
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "zerotier-cli set ec93aa2db6977845 allowManaged=0" ## QHYB

# sh teamcity-zerotier-manage.sh -h 10.166.30.83
