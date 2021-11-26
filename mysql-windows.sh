#!/bin/sh

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
alter user user() identified by "password";

## grant BACKUP_ADMIN
grant BACKUP_ADMIN on *.* to 'root'@'%';

## flush PRIVILEGES
FLUSH PRIVILEGES;
