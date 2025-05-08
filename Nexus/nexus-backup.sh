#!/bin/sh

# zip
rm -rf /root/backup/nexus
mkdir -p /root/backup/nexus
cd /root/nexus || exit
zip -r /root/backup/nexus/nexus.zip ./*
