#!/bin/sh

## install mysql ##
dnf -y install @mysql

systemctl enable mysqld
## run the mysql server ##
systemctl start mysqld

## Myslq8 ##
## update password ##
# alter user user() identified by "password";
## enable root remote login ##
# use mysql;
# select host, user, authentication_string, plugin from user;
# update user set host='%' where user ='root';
# update user set host='localhost' where user ='root'; ## disable root remote login
# flush privileges;

## add user
# create user ry@'%' identified by 'cellxiot654321';
# grant all privileges on ry-vue.* to ry@'%';

## open port 3306
firewall-cmd --add-port=3306/tcp --zone=public --permanent
firewall-cmd --reload
firewall-cmd --list-ports
