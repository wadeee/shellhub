#!/bin/sh

remote_host="$1"
remote_user="root"
remote_port=22
ssh_key=~/.ssh/id_rsa

## config SSL
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "rm -rf /etc/pki/tls/myCA && rm -rf /etc/pki/tls/server"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "mkdir -p /etc/pki/tls/myCA && mkdir -p /etc/pki/tls/server"
scp -P ${remote_port} -i ${ssh_key} ./caconfig.cnf ${remote_user}@"${remote_host}":/etc/pki/tls/myCA/
scp -P ${remote_port} -i ${ssh_key} ./server.ext ${remote_user}@"${remote_host}":/etc/pki/tls/server/
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "openssl req -x509 -newkey rsa:2048 -out /etc/pki/tls/myCA/cacert.cer -outform PEM -keyout /etc/pki/tls/myCA/cacert.pvk -days 1000000 -verbose -config /etc/pki/tls/myCA/caconfig.cnf -nodes -sha256 -subj \"/CN=wade\""
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "openssl req -newkey rsa:2048 -keyout /etc/pki/tls/server/server.pvk -out /etc/pki/tls/server/server.req -subj /CN=*.wade.org.cn -sha256 -nodes"
ssh -p ${remote_port} -i ${ssh_key} ${remote_user}@"${remote_host}" "openssl x509 -req -CA /etc/pki/tls/myCA/cacert.cer -CAkey /etc/pki/tls/myCA/cacert.pvk -in /etc/pki/tls/server/server.req -out /etc/pki/tls/server/server.cer -days 1000000 -extfile /etc/pki/tls/server/server.ext -sha256 -set_serial 0x1111"
