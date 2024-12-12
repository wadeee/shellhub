#!/bin/sh

# zip
mkdir -p /root/backup/
mv -f /root/backup/mayercnc_web.sql /root/backup/mayercnc_web.pre.sql
mysqldump -uroot -ppassword --disable-keys --create-options --skip-extended-insert --routines mayercnc_web > /root/backup/mayercnc_web.sql
