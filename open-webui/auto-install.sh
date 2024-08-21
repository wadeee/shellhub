#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./auto-install.sh [OPTIONS]"
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

## get open-webui.zip ##
## docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
## apt update
## apt install -y zip
## cd /app && zip -r /open-webui.zip ./*

## set timezone ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "timedatectl set-timezone Asia/Shanghai"

## apt update
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git ffmpeg vim curl"

## install nginx
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install -y nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /etc/nginx/sites-enabled/default"
scp -P "$remote_port" -i $ssh_key ./config/open.webui.nginx.http.conf "$remote_user"@"$remote_host":/etc/nginx/conf.d/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl stop nginx"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl start nginx"

## install sqlite3
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install libsqlite3-dev -y"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install sqlite3 -y"

## install python 3.11.9
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libsqlite3-dev libffi-dev libbz2-dev wget"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "tar -xf Python-3.11.9.tgz"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd /root/Python-3.11.9 && ./configure && make && make install"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/python"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/python3"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/pip"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -f /usr/bin/pip3"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/local/bin/python3.11 /usr/bin/python"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/local/bin/python3.11 /usr/bin/python3"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/local/bin/pip3.11 /usr/bin/pip"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ln -s /usr/local/bin/pip3.11 /usr/bin/pip3"

## open-webui
scp -P "$remote_port" -i $ssh_key ./open-webui.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /root/open-webui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/open-webui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "unzip /root/open-webui.zip -d /root/open-webui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd /root/open-webui/backend/ && pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple"
scp -P "$remote_port" -i $ssh_key ./config/open-webui.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
scp -P "$remote_port" -i $ssh_key ./config/.env "$remote_user"@"$remote_host":/root/open-webui/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable open-webui"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart open-webui"

## download ollama
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "curl -fsSL https://ollama.com/install.sh | sh"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "ollama pull llama3.1:8b"
