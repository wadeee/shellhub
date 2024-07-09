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

## update selinux config ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setenforce permissive"
scp -P "$remote_port" -i $ssh_key ./selinux/config "$remote_user"@"$remote_host":/etc/selinux/

## install ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y java-1.8.0-openjdk-devel.x86_64"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch"
scp -P "$remote_port" -i $ssh_key ./elasticsearch.repo "$remote_user"@"$remote_host":/etc/yum.repos.d/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y elasticsearch"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y logstash"
scp -P "$remote_port" -i $ssh_key ./01-logstash-simple.conf "$remote_user"@"$remote_host":/etc/logstash/conf.d/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=9200/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 9200"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=9600/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 9600"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable elasticsearch"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart elasticsearch"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable logstash"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart logstash"
