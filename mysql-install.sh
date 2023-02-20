#!/bin/sh

## install mysql ##
dnf -y install @mysql

systemctl enable mysqld
## run the mysql server ##
systemctl start mysqld

## update password ##
# alter user user() identified by "password";
## enable root remote login ##
# use mysql;
# select host, user, authentication_string, plugin from user;
# update user set host='%' where user ='root';
# update user set host='localhost' where user ='root'; ## disable root remote login
# flush privileges;

## update password & enable root remote login ##
# alter user user() identified by "password"; use mysql; update user set host='%' where user ='root'; flush privileges;

## add user
# create user ry@'%' identified by 'cellxiot654321';
# grant all privileges on ry-vue.* to ry@'%';

## open port 3306
firewall-cmd --add-port=3306/tcp --zone=public --permanent
firewall-cmd --reload
firewall-cmd --list-ports


## windows ##

## my.ini ##
## [mysqld]
## lower_case_table_names=2

## initialize ## remove the /data folder before initialize
mysqld --initialize --console

## registry mysql service
mysqld --install

## start mysql server
net start mysql

## stop mysql server
## net stop mysql

## change root's password
# alter user user() identified by "password";

## grant BACKUP_ADMIN
# grant BACKUP_ADMIN on *.* to 'root'@'%';

## flush PRIVILEGES
# FLUSH PRIVILEGES;

