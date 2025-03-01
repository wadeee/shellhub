#!/bin/sh

## mysqldump export
mysqldump -uroot -ppassword -h192.168.0.90 --port=3306 dbname > C:/Users/Wadec/Desktop/target.sql
mysqldump --result-file=C:/Users/Wadec/Desktop/target.sql --disable-keys --create-options --skip-extended-insert --routines dbname --user=root --host=10.188.30.170 --port=3306
mysqldump -uroot -ppassword --disable-keys --create-options --skip-extended-insert --routines mayercnc_web > /root/backup/mayercnc_web.sql

## mysql import
mysql -uroot -ppassword -h192.168.0.90 --port=3306 dbname < C:/Users/Wadec/Desktop/target.sql

## run sql
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "USE `dbname`; SOURCE /root/sql/target.sql;"
mysql -uroot -ppassword -h192.168.0.90 --port=3306 -s -e "USE `dbname`; SHOW SCHEMAS;"

## mysql secure installation
mysql_secure_installation

## mysql binlog
mysqlbinlog --no-defaults --start-datetime="2024-09-26 15:00:00" --stop-datetime="2024-09-26 15:01:00" binlog.000001 | grep tablename
mysqlbinlog --stop-position=11256359 binlog.000001 | mysql -uroot -p
mysqlbinlog --stop-position=11256359 binlog.000001 | mysql -uroot -p --force
