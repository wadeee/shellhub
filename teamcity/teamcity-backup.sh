#!/bin/sh

# zip
rm -rf /root/backup/teamcity
mkdir -p /root/backup/teamcity
cd /root/TeamCity || exit
zip -r /root/backup/teamcity/TeamCity.zip ./*
cd /root/buildAgent || exit
zip -r /root/backup/teamcity/buildAgent.zip ./*
cd /root/.BuildServer || exit
zip -r /root/backup/teamcity/.BuildServer.zip ./*
mysqldump -uroot -ppassword --disable-keys --create-options --skip-extended-insert --routines --events --triggers --default-character-set=utf8mb4 --single-transaction teamcity > /root/backup/teamcity/teamcity.sql
