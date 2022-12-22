#!/bin/sh

## new a file
touch a.txt
vi a.txt

## print file
cat a.txt

## copy file
cat a.txt > b.txt

## move file
mv a.txt b.txt

## tail line real time
tail -n 3 -f /var/log/dnf.log

## get arch info
arch

## get system info
uname -a

## rpm install
rpm -ivh /root/software/redis-6.2.6-2.1.x86_64.rpm

## rpm installed list
rpm -qa | grep redis

## uninstall rpm
rpm -e redis-5.0.3-5.module_el8.4.0+955+7126e393.x86_64

## dnf install
dnf install -y nginx

## dnf list software
dnf list ## list all
dnf list installed ## list installed
dnf list available ## list available
dnf list nginx ## list nginx

## dnf uninstall
dnf remove -y nginx

## zip
cd /root/temp || exit
zip -r /root/temp.zip ./*

## unzip
unzip /root/temp.zip -d /root/temp1

## chmod all runnable
chmod +x ./*.sh

## timedate
timedatectl status
timedatectl set-timezone Asia/Shanghai


## add user
adduser git
useradd git

## remove user
userdel git
userdel -r git  ## remove with the files

## change password
passwd git

## change authorization
chsh git -s $(which git-shell)
chsh git -s $(which bash)
