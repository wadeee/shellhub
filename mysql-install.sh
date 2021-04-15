#!/bin/sh

## install mysql ##
dnf install @mysql

systemctl enable mysqld
## run the mysql server ##
systemctl start mysqld
