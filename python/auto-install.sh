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

## install python 3.11.9
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "sudo dnf install -y @development zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel libffi-devel findutils"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "tar -xf Python-3.11.9.tgz"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd /root/Python-3.11.9 && ./configure && make && make install"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y python3.11"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "python3.11 -m ensurepip"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/python"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/python3"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/pip"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/pip3"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/bin/python3.11 /usr/bin/python"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/bin/python3.11 /usr/bin/python3"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/local/bin/pip3.11 /usr/bin/pip"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/local/bin/pip3.11 /usr/bin/pip3"
