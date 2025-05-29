#!/bin/sh

## flash iso to disk
diskutil list
diskutil unmountDisk /dev/disk4
sudo dd if=/Users/wade/Desktop/zh-cn_windows_11_business_editions_version_24h2_updated_may_2025_x64_dvd_b388d91e.iso of=/dev/rdisk4 bs=1m
diskutil eject /dev/disk4
