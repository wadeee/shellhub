#!/bin/sh

## download
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.0.14/bin/apache-tomcat-10.0.14.tar.gz
## wget https://archive.apache.org/dist/tomcat/tomcat-6/v6.0.44/bin/apache-tomcat-6.0.44.tar.gz

## install
mkdir /opt/tomcat
tar -xvf apache-tomcat-10.0.14.tar.gz -C /opt/tomcat --strip-components=1

## add user
vi /opt/tomcat/conf/tomcat-users.xml
#<tomcat-users>
#  <role rolename="admin-gui"/>
#  <user username="admin" password="MyAdminPassword" roles="admin-gui"/>
#  <role rolename="manager-gui"/>
#  <user username="admin" password="MyManagerPassword" roles="manager-gui"/>
#</tomcat-users>

## config IP
vim  /opt/tomcat/webapps/manager/META-INF/context.xml
#<Context antiResourceLocking="false" privileged="true" >
#  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
#         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.50.2" />
#</Context>

## config IP
vim  /opt/tomcat/webapps/host-manager/META-INF/context.xml
#<Context antiResourceLocking="false" privileged="true" >
#  <Valve className="org.apache.catalina.valves.RemoteAddrValve"
#         allow="127\.\d+\.\d+\.\d+|::1|0:0:0:0:0:0:0:1|192.168.50.2" />
#</Context>
