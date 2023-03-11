#!/bin/sh

## mysqldump export
mysqldump -uroot -ppassword -h192.168.0.90 --port=3306 dbname > C:/Users/Wadec/Desktop/target.sql

## mysql import
mysql -uroot -ppassword -h192.168.0.90 --port=3306 dbname < C:/Users/Wadec/Desktop/cellx_base.sql

## run sql
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "source /root/sql/cellx_base.sql;"
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "use cellx_base; show schemas;"

##