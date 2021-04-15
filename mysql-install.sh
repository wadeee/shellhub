#!/bin/sh

## install mysql ##
dnf -y install @mysql

systemctl enable mysqld
## run the mysql server ##
systemctl start mysqld
