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

## install teamcity ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl stop teamcity-agent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /root/buildAgent && mkdir -p /root/buildAgent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget -O buildAgentFull.zip http://localhost/update/buildAgentFull.zip && unzip -o buildAgentFull.zip -d /root/buildAgent"

## upload config ##
scp -P "$remote_port" -i $ssh_key ./teamcity-agent.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
scp -P "$remote_port" -i $ssh_key ./settings.xml "$remote_user"@"$remote_host":/root/buildAgent/tools/maven3_9/conf/

## add services ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable teamcity-agent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart teamcity-agent"
