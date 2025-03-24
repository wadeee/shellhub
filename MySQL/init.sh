#!/bin/sh

# vi /etc/my.cnf

systemctl stop mysqld
rm -rf /var/lib/mysql/*
mysqld --initialize --user=mysql
cat /var/log/mysqld.log
systemctl start mysqld
