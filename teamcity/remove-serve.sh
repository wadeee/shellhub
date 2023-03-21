#!/bin/sh

ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "rm -f /usr/lib/systemd/system/teamcity.service"
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "rm -f /usr/lib/systemd/system/teamcity-agent.service"
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "rm -f /etc/nginx/conf.d/teamcity.nginx.http.conf"

ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "systemctl daemon-reload"
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "systemctl restart nginx"

ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "rm -f /root/TeamCity-2021.1.2.tar.gz"
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "rm -rf /root/TeamCity"
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "rm -rf /var/local/buildagent"
