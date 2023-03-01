#!/bin/sh

## create 1mb empty file
set /a var = 1024*1024
fsutil file createnew C:/Users/Wadec/Desktop/a.txt %var%
