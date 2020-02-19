#!/bin/sh

# install nginx
yum install -y nginx

# autorun when booting
systemctl enable nginx
systemctl start nginx
