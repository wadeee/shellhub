#!/bin/sh

## install redis ##
yum -y install redis

systemctl enable redis
systemctl start redis
