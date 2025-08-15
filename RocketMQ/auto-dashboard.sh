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

## install git##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y git"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y maven"
#
### get rocketmq-dashboard
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "git clone https://github.com/apache/rocketmq-dashboard.git"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd rocketmq-dashboard && mvn clean package -Dmaven.test.skip=true"
#scp -P "$remote_port" -i $ssh_key ./rocketmq-dashboard.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable rocketmq-dashboard"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart rocketmq-dashboard"

## build rocketmq-dashboard
git clone https://github.com/apache/rocketmq-dashboard.git
cd rocketmq-dashboard || exit
JAVA_HOME="C:\Users\Wadec\.jdks\temurin-17.0.15" mvn clean package -Dmaven.test.skip=true
cd ..

## firewall
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --add-port=8082/tcp --zone=public --permanent"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "semanage port -a -t http_port_t -p tcp 8082"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "firewall-cmd --reload"

## service
scp -P "$remote_port" -i $ssh_key ./rocketmq-dashboard/target/rocketmq-dashboard-2.0.1-SNAPSHOT.jar "$remote_user"@"$remote_host":/root/jars/
scp -P "$remote_port" -i $ssh_key ./rocketmq-dashboard.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable rocketmq-dashboard"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart rocketmq-dashboard"
