#!/bin/sh

## git command ##
dnf install -y git
git stash list
git stash -m 'message'
git stash pop
git stash pop stash@{1}
git stash clear
git checkout -b dev_branch
git checkout ds89fsu89
git checkout -f
git rebase -i HEAD~5
git rebase main
git reset HEAD^
git reset --hard HEAD~2
git push -f
git pull -f origin main:main
git push origin --delete dev_branch

## git serve ##
git init --bare cellxiot.git
adduser git
passwd git
chown -R git:git cellxiot.git
chsh git -s $(which git-shell)
# chsh git -s $(which bash)
## git clone git@server:/srv/cellxiot.git
## git clone ssh://git@office.cellx.com.cn:36010/srv/cellxiot.git

## git config
## git config list
git config --list
git config --system --list
git config --global --list
## set git config
git config --global user.name "Wade"
git config --global user.email "wadechen@outlook.com"
