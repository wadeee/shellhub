#!/bin/sh

## mysqldump export
mysqldump -uroot -ppassword -h192.168.0.90 --port=3306 dbname > C:/Users/Wadec/Desktop/target.sql

## mysql import
mysql -uroot -ppassword -h192.168.0.90 --port=3306 dbname < C:/Users/Wadec/Desktop/target.sql

## run sql
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "SOURCE /root/sql/target.sql;"
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "USE `dbname`; SHOW SCHEMAS;"
