#!/bin/sh

## add nacos to service ##
echo y | cp ./nacos.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable nacos
systemctl restart nacos
