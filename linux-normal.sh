#!/bin/sh

## copy file
cat a.txt
cat a.txt > b.txt

## move file
mv a.txt b.txt

## tail line real time
tail -n 3 -f /var/log/dnf.log

## get system arch info
arch
uname -a

## rpm install
rpm -ivh /root/software/redis-6.2.6-2.1.x86_64.rpm

rpm -qa

## uninstall rpm
rpm -e

## epel
yum -y install epel-release

## unzip
unzip a.zip -d /root/temp
