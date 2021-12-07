#!/bin/sh

vm_path="C:/Users/wade/Documents/Virtual Machines/"
origin_vm="CentOS 8 clean"
target_vm="$1"

mkdir -p "${vm_path}${target_vm}"
cp -r "${vm_path}${origin_vm}"/* "${vm_path}${target_vm}/"
