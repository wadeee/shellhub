#!/bin/sh

## install mysql ##
dnf -y install @mysql

systemctl enable mysqld
## run the mysql server ##
systemctl start mysqld

## Myslq8 ##
## update password ##
# mysqladmin -u root -p password 'new password'
## enable root remote login ##
# use mysql;
# update user set host='%' where user ='root';
