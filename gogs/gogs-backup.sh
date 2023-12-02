#!/bin/sh

# zip
rm -rf /mnt/data/*
cd /home/git || exit
zip -r /mnt/data/home-git.zip ./*
cd /root/gogs || exit
zip -r /mnt/data/root-gogs.zip ./*
