#!/bin/sh

# zip
mkdir -p /root/backup/
mv -f /root/backup/name_generator.sql /root/backup/name_generator.pre.sql
mysqldump -uroot -p782231 name_generator > /root/backup/name_generator.sql
