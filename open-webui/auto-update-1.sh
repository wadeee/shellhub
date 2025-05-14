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

## open-webui
scp -P "$remote_port" -i $ssh_key ./open-webui.zip "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install zip -y"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf /root/open-webui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /root/open-webui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "unzip /root/open-webui.zip -d /root/open-webui/"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd /root/open-webui/backend/ && source /root/anaconda3/etc/profile.d/conda.sh && conda activate open-webui && pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple"
scp -P "$remote_port" -i $ssh_key ./config/open-webui-temp.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/open-webui.service
scp -P "$remote_port" -i $ssh_key ./config/.env "$remote_user"@"$remote_host":/root/open-webui/backend/
scp -P "$remote_port" -i $ssh_key ./config/.webui_secret_key "$remote_user"@"$remote_host":/root/open-webui/backend/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable open-webui"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart open-webui"
# systemctl status open-webui
