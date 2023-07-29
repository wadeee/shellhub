#!/bin/sh

## copy
cp ./a/a.txt ./b/b.txt
cp -r ./a/b ./cpa/b ## not stable
cp -r ./a/b/* ./cpa/b ## stable

## new a file
touch a.txt
vi a.txt

## print file
cat a.txt

## copy file
cat a.txt > b.txt

## move file or rename file
mv a.txt b.txt

## tail line real time
tail -n 3 -f /var/log/dnf.log

## get arch info
arch

## get system info
uname -a

## rpm install
rpm -ivh /root/software/redis-6.2.6-2.1.x86_64.rpm

## rpm installed list
rpm -qa | grep redis

## uninstall rpm
rpm -e redis-5.0.3-5.module_el8.4.0+955+7126e393.x86_64

## dnf update
dnf update -y

## dnf install
dnf install -y nginx
dnf module install -y nodejs:16

## dnf list software
dnf list ## list all
dnf list installed ## list installed
dnf list available ## list available
dnf list nginx ## list nginx
dnf list maven --showduplicates ## list maven

## dnf uninstall
dnf remove -y nginx

## zip
cd /root/temp || exit
zip -r /root/temp.zip ./*

## unzip
unzip /root/temp.zip -d /root/temp1

## chmod all runnable
chmod +x ./*.sh

## timedate
timedatectl status
timedatectl set-timezone Asia/Shanghai


## add user
adduser git
useradd git

## remove user
userdel git
userdel -r git  ## remove with the files

## change password
passwd git

## change authorization
chsh git -s $(which git-shell)
chsh git -s $(which bash)

## cron
vi /etc/crontab ## config example: 10 18 * * * root systemctl start nginx && crontab -r
systemctl reload crond ## reload /etc/crontab
## crontab /etc/crontab ##
crontab -l ## show list
crontab -r ## remove tasks
crontab -e ## edit tasks
cat /var/log/cron ## log

## find
find . -name "*.c"
find / -name "*.c"
find . -type f ## show all documents

## top
top
# press M ## sort by memory
# press P ## sort by CPU

## see the service
ps aux | grep 1213
## kill <PID>
kill 1213

## set variable
a=hello
echo $a
a=$((1+1))
echo $a
a=$(date)
echo "$a"
a=$(ls)
echo "$a"

## nohup
./shell.sh & ## run in background, but the output will be lost
nohup ./shell.sh ## run in background, and the output will be saved in nohup.out, but the terminal will be blocked
nohup ./shell.sh & ## run in background, and the output will be saved in nohup.out

## proxy set
export all_proxy="localhost:4780"
#export http_proxy="localhost:4780"
#export https_proxy="localhost:4780"
# unset
unset all_proxy
#unset http_proxy
#unset https_proxy

## systemd
systemctl status nginx
systemctl enable nginx
systemctl disable nginx
systemctl start nginx
systemctl stop nginx
systemctl restart nginx
## daemon reload
systemctl daemon-reload
## log
journalctl -u nginx
journalctl -u nginx -f ## log tail line

## brew
brew list
brew install node
brew uninstall node
brew search node
