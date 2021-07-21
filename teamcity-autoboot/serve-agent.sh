#!/bin/sh

## build agent
## docker pull jetbrains/teamcity-agent
## chcon -Rt svirt_sandbox_file_t /root/TeamCity/conf

## http://office.cellx.com.cn:36019/update/buildAgentFull.zip
## unzip buildAgentFull.zip -d /var/local/buildagent
## cd /var/local/buildagent/conf
## cp buildAgent.dist.properties buildAgent.properties
## vi buildAgent.properties ## set the name and serverUrl

## agent config
scp -P 36010 -i C:/Users/wade/.ssh/id_rsa_ssh8 ./teamcity-agent.service root@office.cellx.com.cn:/usr/lib/systemd/system/
ssh -p 36010 -i C:/Users/wade/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "systemctl daemon-reload && systemctl enable teamcity-agent && systemctl restart teamcity-agent"
