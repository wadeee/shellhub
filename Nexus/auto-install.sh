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

## firewall
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setenforce permissive"
scp -P "$remote_port" -i $ssh_key ./selinux/config "$remote_user"@"$remote_host":/etc/selinux/

## install nexus ##
scp -P "$remote_port" -i $ssh_key ./nexus-unix-x86-64-3.78.2-04.tar.gz "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /root/nexus && mkdir -p /root/nexus && cd /root/nexus && tar -xvf /root/nexus-unix-x86-64-3.78.2-04.tar.gz -C /root/nexus"

## nginx ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y nginx"

## install java-1.8 ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y java-1.8.0-openjdk-devel.x86_64"

## firewall
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 80"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=80/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"

## upload config ##
scp -P "$remote_port" -i $ssh_key ./nexus-default.properties "$remote_user"@"$remote_host":/root/nexus/nexus-3.78.2-04/etc/
scp -P "$remote_port" -i $ssh_key ./nexus.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
scp -P "$remote_port" -i $ssh_key ./nginx.conf "$remote_user"@"$remote_host":/etc/nginx/
scp -P "$remote_port" -i $ssh_key ./nexus.nginx.http.conf "$remote_user"@"$remote_host":/etc/nginx/conf.d/

## encryption ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/nexus/secrets"
scp -P "$remote_port" -i $ssh_key ./nexus-secrets.json "$remote_user"@"$remote_host":/root/nexus/secrets/
scp -P "$remote_port" -i $ssh_key ./sonatype-work/nexus.properties "$remote_user"@"$remote_host":/root/nexus/sonatype-work/nexus3/etc/

## add nexus service ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable nexus"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart nexus"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart nginx"
