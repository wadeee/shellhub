#!/bin/sh

## install java-1.8 ##
dnf install -y java-1.8.0-openjdk-devel.x86_64

## set environment parameters ##
echo "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.242.b08-0.el8_1.x86_64" >> /etc/profile
source /etc/profile ## IMPOTANT! for next step ##
echo "export CLASSPATH=.:$JAVA_HOME/jre/lib/rt.jar:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar" >> /etc/profile
echo "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
source /etc/profile

## rerun shell ##
exec $SHELL
