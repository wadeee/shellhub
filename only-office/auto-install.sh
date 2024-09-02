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


ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf clean packages"

# firewall
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "setsebool -P httpd_can_network_connect 1"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 80"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=80/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"

## install nginx
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y nginx"

## upload nginx config ##
scp -P "$remote_port" -i $ssh_key ./nginx.conf "$remote_user"@"$remote_host":/etc/nginx/

## enable nginx
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart nginx"

## install
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y epel-release"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf config-manager --set-enabled -y crb"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y epel-release epel-next-release"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "subscription-manager repos --enable codeready-builder-for-rhel-9-\$(arch)-rpms"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y postgresql postgresql-server"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "service postgresql initdb"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "chkconfig postgresql on"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y chkconfig"
#scp -P "$remote_port" -i $ssh_key ./pg_hba.conf "$remote_user"@"$remote_host":/var/lib/pgsql/data/
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "service postgresql restart"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sudo -i -u postgres psql -c \"CREATE USER onlyoffice WITH PASSWORD 'onlyoffice';\""
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sudo -i -u postgres psql -c \"CREATE DATABASE onlyoffice OWNER onlyoffice;\""
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | os=centos dist=9 sudo bash"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | os=centos dist=9 sudo bash"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y rabbitmq-server"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable --now rabbitmq-server"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y https://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice-repo.noarch.rpm"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y cabextract xorg-x11-font-utils"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y fontconfig"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rpm -i https://sourceforge.net/projects/mscorefonts2/files/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y onlyoffice-documentserver"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export DS_PORT=80' >> ~/.bashrc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export DB_TYPE=mysql' >> ~/.bashrc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export DB_PORT=3306' >> ~/.bashrc"


#bash documentserver-configure.sh
##For PostgreSQL:
##Host: localhost
##Database: onlyoffice
##User: root
##Password: password
##For RabbitMQ:
##Host: localhost
##User: guest
##Password: guest
#systemctl enable --now ds-example.service
