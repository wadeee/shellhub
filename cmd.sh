#!/bin/sh

## remove dir and all files
rmdir /s /q "C:\Program Files\MySQL\MySQL Server 8.0\data"

## create 1mb empty file
fsutil file createnew a.txt 1048576
# or
set /a var = 1024*1024
fsutil file createnew "C:/Users/Wadec/Desktop/a.txt" %var%

## call
call a.bat

## wsl ##
## wsl list ##
wsl --list

## wsl unregister ##
wsl --unregister Ubuntu-20.04

## msi install
msiexec /i "C:\a.msi" /l*v "C:\a-install.log"

## nssm
nssm install servername
nssm start servername
nssm stop servername
nssm restart servername
nssm remove servername
