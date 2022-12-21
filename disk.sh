#!/bin/sh

## disk info
fdisk -l
lsblk
df -h

## disk partition
fdisk /dev/sdb
## add: n p (enter) (enter) w
## delete: d w

## disk format
mkfs.ext4 /dev/sdb1

## auto disk mount
vi /etc/fstab
## add the next line
## /dev/sdb1 /mnt/data ext4 defaults 0 0

## disk mount
mkdir /mnt/data
mount /dev/sdb1 /mnt/data

## disk unmount
umount /dev/sdb1

## make symbolic link
mkdir -p /mnt/data/temp
ln -s /mnt/data/temp /root/temp

## copy and make symbolic link
rm -rf /mnt/data/temp/*
cp -r /root/temp/* /mnt/data/temp
rm -rf /root/temp
ln -s /mnt/data/temp /root/temp
