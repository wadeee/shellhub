#!/bin/sh

## create 1mb empty file
fsutil file createnew a.txt 1048576
# or
set /a var = 1024*1024
fsutil file createnew C:/Users/Wadec/Desktop/a.txt %var%
