#!/bin/sh

git clone https://github.com/alibaba/nacos.git ~/nacos
cd ~/nacos
mvn -Prelease-nacos -Dmaven.test.skip=true clean install -U
ls -al distribution/target/

## cd distribution/target/nacos-server-$version/nacos/bin