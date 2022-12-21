#!/bin/sh

vm_path=~/Documents/Virtual\ Machines/
origin_vm=CentOS8
target_vm=$1

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
    ? ) showHelp ;;
  esac
done

mkdir -p "$vm_path$target_vm"
cp -r "$vm_path$origin_vm"/* "$vm_path$target_vm"/
