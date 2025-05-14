#!/bin/sh

## focus to current dir
CURRENT_DIR=$(dirname $(readlink -f "$0"))
cd "$CURRENT_DIR" || exit

cd ../

## build
npm install --registry=https://mirrors.huaweicloud.com/repository/npm/
npm run build

## copy
rm -rf ./open-webui
mkdir -p ./open-webui
cp -r ./backend ./open-webui/
cp -r ./build ./open-webui/
cp ./CHANGELOG.md ./open-webui/
cp ./package.json ./open-webui/
cd ./open-webui && zip -r ../open-webui.zip ./*
