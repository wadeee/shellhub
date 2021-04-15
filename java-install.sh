#!/bin/sh

## install java-1.8 ##
dnf install -y java-1.8.0-openjdk-devel.x86_64

## set environment parameters ##
## important! this path will change please care ##
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.282.b08-2.el8_3.x86_64" >> /etc/profile
source /etc/profile ## IMPOTANT! for next step ##
echo "export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> /etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
source /etc/profile

## rerun shell ##
exec $SHELL
