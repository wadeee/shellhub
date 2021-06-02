#!/bin/sh

## install redis ##
yum -y install redis

systemctl enable redis
systemctl start redis

## change password
redis-cli
config set requirepass cellxiot654321
redis-cli -a cellxiot654321
