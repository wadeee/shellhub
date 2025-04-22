#!/bin/sh

# zip
rm -rf /mnt/data/*
cd /home/git || exit
zip -r /mnt/data/home-git.zip ./*
cd /root/gogs || exit
zip -r /mnt/data/root-gogs.zip ./*
mysqldump -uroot -ppassword --disable-keys --create-options --skip-extended-insert --routines --events --triggers gogs > /mnt/data/gogs.sql
