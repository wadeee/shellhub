#!/bin/sh

remote_host="$1"
remote_user="root"
remote_port=22
ssh_key=~/.ssh/id_rsa

## set timezone ##
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "timedatectl set-timezone Asia/Shanghai"

## update mirror urls ##
#ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "sed -i -e 's|mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*"
#ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "sed -i -e 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*"

## install mysql ##
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "dnf -y install @mysql"

## enable and start server ##
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "systemctl enable mysqld"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "systemctl start mysqld"

## open port 3306
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "firewall-cmd --add-port=3306/tcp --zone=public --permanent"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "firewall-cmd --reload"
