#!/bin/sh

# install openssh-server
yum install openssh-server

## change the port to 22 at /etc/ssh/sshd_config ##
# vi /etc/ssh/sshd_config

## restart the sshd server ##
# systemctl restart sshd

