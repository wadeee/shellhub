#!/bin/sh

# yum remove docker \
#            docker-client \
#            docker-client-latest \
#            docker-common \
#            docker-latest \
#            docker-latest-logrotate \
#            docker-logrotate \
#            docker-engine

dnf remove docker \
           docker-client \
           docker-client-latest \
           docker-common \
           docker-latest \
           docker-latest-logrotate \
           docker-logrotate \
           docker-selinux \
           docker-engine-selinux \
           docker-engine

# yum install -y yum-utils \
#                device-mapper-persistent-data \
#                lvm2

dnf -y install dnf-plugins-core

# yum-config-manager \
#     --add-repo \
#     https://download.docker.com/linux/centos/docker-ce.repo

dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# dnf config-manager --set-enabled docker-ce-nightly
# dnf config-manager --set-enabled docker-ce-test
# dnf config-manager --set-disabled docker-ce-nightly

## yum install -y containerd.io docker-ce docker-ce-cli ##
## yum list docker-ce --showduplicates | sort -r ##
# yum install -y containerd.io-1.2.0-3.el7 docker-ce-3:18.09.0-3.el7 docker-ce-cli-1:18.09.0-3.el7

dnf install -y containerd.io-1.2.0-3.el7 docker-ce-3:18.09.0-3.el7 docker-ce-cli-1:18.09.0-3.el7

systemctl start docker
