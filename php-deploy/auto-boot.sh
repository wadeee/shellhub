#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./auto-boot.sh [OPTIONS]"
  echo "Options:"
  echo "  -h <ssh host>"
  echo "  -p <ssh port>"
  echo "  -u <ssh user>"
  exit;
}

while getopts "h:p:u:s" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    ? ) showHelp ;;
  esac
done

## focus to current dir
CURRENT_DIR="$(realpath "$(dirname "$0")")"
cd "$CURRENT_DIR" || exit

## firewall
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=80/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 80"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"

## update selinux config ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setenforce permissive"
scp -P "$remote_port" -i $ssh_key ./config/config "$remote_user"@"$remote_host":/etc/selinux/

## git clone
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "git clone http://10.166.30.82/sesintec/sesintec-pages.git /var/www/sesintec-pages/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "chown -R nginx:nginx /var/www/sesintec-pages"

## upload config
scp -P "$remote_port" -i $ssh_key ./config/nginx.conf "$remote_user"@"$remote_host":/etc/nginx/
scp -P "$remote_port" -i $ssh_key ./config/sesintec-pages.conf "$remote_user"@"$remote_host":/etc/nginx/conf.d/
scp -P "$remote_port" -i $ssh_key ./config/www.conf "$remote_user"@"$remote_host":/etc/php-fpm.d/

## restart nginx and service
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart php-fpm"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart nginx"
