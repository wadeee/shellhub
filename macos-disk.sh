#!/bin/sh

## flash iso to disk fat32
diskutil list
file /Users/wade/Desktop/zh-cn_windows_11_business_editions_version_24h2_updated_may_2025_x64_dvd_b388d91e.iso
diskutil eraseDisk FAT32 "WINDOWS" /dev/disk4
hdiutil mount /Users/wade/Desktop/zh-cn_windows_11_business_editions_version_24h2_updated_may_2025_x64_dvd_b388d91e.iso
cp -R /Volumes/ISOVolume/* /Volumes/WINDOWS/

## flash iso to disk
diskutil list
diskutil unmountDisk /dev/disk4
sudo dd if=/Users/wade/Desktop/zh-cn_windows_11_business_editions_version_24h2_updated_may_2025_x64_dvd_b388d91e.iso of=/dev/rdisk4 bs=1m
diskutil eject /dev/disk4

## get infos
diskutil list
diskutil info /dev/disk4
