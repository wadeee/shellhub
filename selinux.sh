#!/bin/sh

## SELinux
## see the http ports
semanage port -l | grep http

## add http port
semanage port -a -t http_port_t -p tcp 36019

## remove http port
# semanage port -d -t http_port_t -p tcp 36019

## 启用网络访问配置
setsebool -P httpd_can_network_connect 1

## SELinux status
sestatus -v

##设置SELinux 成为permissive模式
# setenforce 0

##设置SELinux 成为enforce模式
# setenforce 1
