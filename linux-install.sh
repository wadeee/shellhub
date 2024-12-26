#!/bin/sh

Linuxefi /images/pxeboot/vmlinuz linux dd quiet
## sdb4为U盘分区
Linuxefi /images/pxeboot/vmlinuz inst.stage2=hd:/dev/sdb4 quiet
