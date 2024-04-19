#!/bin/sh

vm_path=~/Documents/Virtual\ Machines/
origin_vm="CentOS stream 8"
target_vm="c8 t1"
## macOS
#vm_path=~/Virtual\ Machines.localized/
#origin_vm="CentOS 9 origin.vmwarevm"
#target_vm=

showHelp() {
  echo "Usage: sh ./VM-copy.sh [OPTIONS]"
  echo "Options:"
  echo "  -p <vm_path>"
  echo "  -o <origin_vm>"
  echo "  -t <target_vm>"
  exit;
}

while getopts "p:o:t:" opt; do
  case "$opt" in
    p ) vm_path=$OPTARG ;;
    o ) origin_vm=$OPTARG ;;
    t ) target_vm=$OPTARG ;;
#    t ) target_vm="$OPTARG.vmwarevm" ;;
    ? ) showHelp ;;
  esac
done

mkdir -p "$vm_path$target_vm"
cp -r "$vm_path$origin_vm"/* "$vm_path$target_vm"/
