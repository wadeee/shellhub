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

## install ms sql server
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rpm --import https://packages.microsoft.com/keys/microsoft.asc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/9/mssql-server-2022.repo"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y mssql-server"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable mssql-server"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl start mssql-server"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -o /etc/yum.repos.d/msprod.repo https://packages.microsoft.com/config/rhel/9/prod.repo"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y mssql-tools unixODBC-devel"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export PATH=\"\$PATH:/opt/mssql-tools/bin\"' >> ~/.bashrc"

## config
# dnf install -y mssql-tools
# /opt/mssql/bin/mssql-conf setup
# sqlcmd -S localhost -U sa -P 'password'
