#!/bin/sh

# download and unzip
# wget https://download.jetbrains.com/teamcity/TeamCity-2021.1.2.tar.gz
# tar zxf TeamCity-2021.1.2.tar.gz
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "wget https://download.jetbrains.com/teamcity/TeamCity-2021.1.2.tar.gz && tar zxf TeamCity-2021.1.2.tar.gz"

## add teamcity to service ##
scp -P 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 ./teamcity.service root@office.cellx.com.cn:/usr/lib/systemd/system/
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "systemctl daemon-reload && systemctl enable teamcity && systemctl restart teamcity"

## nginx config
scp -P 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 ./teamcity.nginx.http.conf root@office.cellx.com.cn:/etc/nginx/conf.d/
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "systemctl restart nginx"
