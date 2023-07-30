#!/bin/sh

## install and uninstall
nvm install node
nvm install 16
nvm install 18
nvm uninstall 18

## list
nvm ls
nvm ls-remote

## use right now, but not default
nvm use 16

## alias
nvm alias default 16
