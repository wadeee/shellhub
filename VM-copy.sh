#!/bin/sh

vm_path="C:/Users/wadec/Documents/Virtual Machines/"
origin_vm="CentOS8.5"
target_vm="$1"

mkdir -p "${vm_path}${target_vm}"
cp -r "${vm_path}${origin_vm}"/* "${vm_path}${target_vm}/"
