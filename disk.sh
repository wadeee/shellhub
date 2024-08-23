#!/bin/sh

## disk info
fdisk -l
lsblk
df -h
df -h /var ## 查看/var在文件系统的位置

## disk partition
fdisk /dev/sdb
## add: n p (enter) (enter) w
## delete: d w

## disk format
mkfs.xfs /dev/sdb1
# mkfs.ext4 /dev/sdb1
## if failed
# dmsetup status
# dmsetup remove_all

## auto disk mount
vi /etc/fstab
## add the next line
## /dev/sdb1 /mnt/data xfs defaults 0 0
## /dev/sdb1 /mnt/data ext4 defaults 0 0
mount -a

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

## extend
lsblk
fdisk /dev/sda
# add: n (enter) (enter) p w
pvcreate /dev/sda3
pvdisplay ## see VG name
vgextend cs /dev/sda3
vgdisplay
fdisk -l
lvextend -l +100%FREE /dev/mapper/cs-home
xfs_growfs /dev/mapper/cs-home
df -h

## power off sudden ##
lvm
pvs
vgs
lvs
mount /dev/vg_name/lv_root /sysroot
## mount /dev/cs/root /sysroot
xfs_repair /dev/sda1
mount /dev/cs/root /sysroot
smartctl -a /dev/sda
