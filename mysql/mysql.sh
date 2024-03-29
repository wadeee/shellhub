#!/bin/sh

## mysqldump export
mysqldump -uroot -ppassword -h192.168.0.90 --port=3306 dbname > C:/Users/Wadec/Desktop/target.sql
mysqldump --result-file=C:/Users/Wadec/Desktop/target.sql --disable-keys --create-options --skip-extended-insert --routines dbname --user=root --host=10.188.30.170 --port=3306

## mysql import
mysql -uroot -ppassword -h192.168.0.90 --port=3306 dbname < C:/Users/Wadec/Desktop/target.sql

## run sql
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "USE `dbname`; SOURCE /root/sql/target.sql;"
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "USE `dbname`; SHOW SCHEMAS;"
