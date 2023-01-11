#!/bin/sh

## SELinux
## see the http ports
semanage port -l | grep http

## add http port
semanage port -a -t http_port_t -p tcp 36019

## add udp port
semanage port -a -t http_port_t -p udp 36019

## remove http port
# semanage port -d -t http_port_t -p tcp 36019

## 启用网络访问配置
setsebool -P httpd_can_network_connect 1

## 获得SELINUX配置参数
getsebool -a | grep httpd_can_network_connect

## SELinux status
sestatus -v

## SELINUX临时状态设置
setenforce permissive
## enforcing   ## 强制模式（默认）
## permissive  ## 宽容模式
## disabled    ## 禁用

## SELINUX状态设置
vi /etc/selinux/config
reboot
## SELINUX=enforcing   ## 强制模式（默认）
## SELINUX=permissive  ## 宽容模式
## SELINUX=disabled    ## 禁用
