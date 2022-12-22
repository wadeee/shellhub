#!/bin/sh

## this is not runable in Windows OS. ##
docker pull centos
docker run -itd --name=centos --privileged centos /sbin/init
docker exec -it centos bash
