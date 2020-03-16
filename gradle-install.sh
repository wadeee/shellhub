#!/bin/sh

## install zip and unzip ##
dnf install -y zip
dnf install -y unzip
# reboot

## install SDK man ##
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
# echo 'source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.zshrc

# sdk version

## install gradle
sdk install gradle
