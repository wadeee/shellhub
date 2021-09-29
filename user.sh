#!/bin/sh

## add user
adduser git
useradd git

## remove user
userdel git
userdel -r git  ## remove with the files

## change password
passwd git

## change authorization
chsh git -s $(which git-shell)
chsh git -s $(which bash)
