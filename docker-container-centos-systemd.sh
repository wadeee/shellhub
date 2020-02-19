#!/bin/sh

# this is not runable in windows os.
docker pull centos
docker run -itd --name=NAME --privileged centos /sbin/init
docker exec -it NAME bash
