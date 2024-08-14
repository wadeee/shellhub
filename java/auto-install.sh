#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./inst.sh [OPTIONS]"
  echo "Options:"
  echo "  -h <ssh host>"
  echo "  -p <ssh port>"
  echo "  -u <ssh user>"
  exit;
}

while getopts "h:p:u:" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    ? ) showHelp ;;
  esac
done

## install java-1.8 JDK##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y java-1.8.0-openjdk-devel"

## install java-1.8 JRE##
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y java-1.8.0-openjdk"

## install java-1.8 JRE without GUI##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install -y java-1.8.0-openjdk-headless"

## install java 11 ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install java-11-openjdk"

## install java 17 ##
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "dnf install java-17-openjdk"
