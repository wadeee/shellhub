#!/bin/sh

## build agent

## http://office.cellx.com.cn:36019/update/buildAgentFull.zip
## unzip buildAgentFull.zip -d /var/local/buildagent
## cd /var/local/buildagent/conf
## cp buildAgent.dist.properties buildAgent.properties
## vi buildAgent.properties ## set the name and serverUrl
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "wget http://localhost:36009/update/buildAgentFull.zip && unzip buildAgentFull.zip -d /var/local/buildagent"

## agent config
scp -P 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 ./teamcity-agent.service root@office.cellx.com.cn:/usr/lib/systemd/system/
ssh -p 36000 -i C:/Users/TS/.ssh/id_rsa_ssh8 root@office.cellx.com.cn "systemctl daemon-reload && systemctl enable teamcity-agent && systemctl restart teamcity-agent"
