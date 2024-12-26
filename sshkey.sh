#!/bin/sh

ssh-keygen -t rsa -C "youremail.com"

## generate keygen for OpenSSH_8.0
ssh-keygen -m PEM -t rsa -C "youremail.com"
ssh-keygen -m PEM -t rsa -C "youremail.com" -f ~/.ssh/id_rsa_ssh8

## remove the host identification
ssh-keygen -R 192.168.0.147
ssh-keygen -R [192.168.0.147]:10023

## add public key to the server
ssh-copy-id -i ~/.ssh/id_rsa root@192.168.0.91
ssh-copy-id -p 22 -i ~/.ssh/id_rsa root@192.168.0.91
## scp /c/Users/TS/.ssh/id_rsa.pub root@192.168.0.91:~/.ssh/wade.pub
## cat wade.pub >>~/.ssh/authorized_keys
