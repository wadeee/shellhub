#!/bin/sh

## git command ##

git stash -m 'message'

git stash pop

git stash pop stash@{1}

git checkout -b dev_branch

git checkout ds89fsu89

git checkout -f

git rebase -i HEAD~5

git rebase main

git reset HEAD^

git reset --hard HEAD~2

git push -f

git pull -f origin main:main
