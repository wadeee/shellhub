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
