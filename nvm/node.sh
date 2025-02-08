#!/usr/bin/env bash

npm install --registry=https://mirrors.huaweicloud.com/repository/npm/
npm config set proxy http://localhost:7890
npm config set https-proxy http://localhost:7890
