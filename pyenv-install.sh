#!/bin/sh

# install dependency package
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel xz-devel make -y
# db4-devel libpcap-devel

# download pyenv
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

# set environment parameters
echo "export PYENV_HOME=$HOME/.pyenv" >> /etc/profile
source /etc/profile
echo "export PATH=$PATH:$PYENV_HOME/bin" >> /etc/profile
echo 'eval "$(pyenv init -)"' >> /etc/profile
source /etc/profile

# rerun shell
exec $SHELL
