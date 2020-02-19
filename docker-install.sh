#!/bin/sh

yum remove docker \
           docker-client \
           docker-client-latest \
           docker-common \
           docker-latest \
           docker-latest-logrotate \
           docker-logrotate \
           docker-engine

yum install -y yum-utils \
               device-mapper-persistent-data \
               lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

#yum install -y containerd.io docker-ce docker-ce-cli
#yum list docker-ce --showduplicates | sort -r
yum install -y containerd.io-1.2.0-3.el7 docker-ce-3:18.09.0-3.el7 docker-ce-cli-1:18.09.0-3.el7

systemctl start docker
