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

## install sqlite3
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y gcc make readline-devel"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://www.sqlite.org/2024/sqlite-autoconf-3460100.tar.gz"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "tar xvfz sqlite-autoconf-3460100.tar.gz"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd sqlite-autoconf-3460100 && ./configure --prefix=/usr/local && make && make install"

## install sqlite3
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y gcc make readline-devel"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://www.sqlite.org/2024/sqlite-src-3460100.zip"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "unzip sqlite-src-3460100.zip"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd sqlite-src-3460100 && ./configure --prefix=/usr/local && make && make install"
