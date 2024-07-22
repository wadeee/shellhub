#!/bin/sh

# zip
rm -rf /root/backup/teamcity
mkdir -p /root/backup/teamcity
cd /root/TeamCity || exit
zip -r /root/backup/teamcity/TeamCity.zip ./*
cd /root/buildAgent || exit
zip -r /root/backup/teamcity/buildAgent.zip ./*
mysqldump -uroot -ppassword -hlocalhost --port=3306 teamcity > /root/backup/teamcity/teamcity.sql
