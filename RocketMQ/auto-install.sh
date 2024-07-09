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
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "wget https://archive.apache.org/dist/rocketmq/5.2.0/rocketmq-all-5.2.0-bin-release.zip"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "rm -rf rocketmq-all-5.2.0-bin-release"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "unzip rocketmq-all-5.2.0-bin-release.zip"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export ROCKETMQ_HOME=/root/rocketmq-all-5.2.0-bin-release' >> ~/.bashrc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=9876/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 9876"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=10911/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 10911"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"
scp -P "$remote_port" -i $ssh_key ./mqnamesrv.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
scp -P "$remote_port" -i $ssh_key ./rocketmq.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable mqnamesrv"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart mqnamesrv"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable rocketmq"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart rocketmq"
