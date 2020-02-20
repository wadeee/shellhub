#!/bin/sh

## install openssh-server ##
# yum install -y openssh-server
dnf install -y openssh-server

## change the port to 22 at /etc/ssh/sshd_config ##
# vi /etc/ssh/sshd_config

## restart the sshd server ##
# systemctl restart sshd

