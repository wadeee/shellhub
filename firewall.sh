#!/bin/sh

## firewall
## close firewall
# systemctl stop firewalld

## list ports
firewall-cmd --list-ports

## add port
firewall-cmd --add-port=36019/tcp --zone=public --permanent

## add udp port
firewall-cmd --add-port=36019/udp --zone=public --permanent

## reload
firewall-cmd --reload

## remove port
# firewall-cmd --remove-port=36019/tcp --zone=public --permanent
