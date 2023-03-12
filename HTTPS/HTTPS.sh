#!/bin/sh

## make dir /root/https/myCA/signedcerts and /root/https/myCA/private
mkdir -p /root/https/myCA/signedcerts && mkdir -p /root/https/myCA/private && cd /root/https/myCA
echo '01' > serial && touch index.txt

## copy caconfig.cnf to /root/https/myCA/

openssl req -x509 -newkey rsa:2048 -out cacert.pem -outform PEM -days 1825 -config /root/https/myCA/caconfig.cnf

## make dir /root/https/server
mkdir -p /root/https/server && cd /root/https/server

## copy server.cnf to /root/https/server/

openssl req -newkey rsa:2048 -keyout tempkey.pem -keyform PEM -out tempreq.pem -outform PEM -config /root/https/server/server.cnf

openssl rsa < tempkey.pem > server_key.pem

openssl ca -in tempreq.pem -out server_crt.pem -config /root/https/myCA/caconfig.cnf

rm tempkey.pem && rm tempreq.pem

## nginx config
##server {
##    ssl on;
##    ssl_certificate /root/https/server/server_crt.pem;
##    ssl_certificate_key /root/https/server/server_key.pem;
##    ssl_session_timeout 5m;
##    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
##    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;
##    ssl_prefer_server_ciphers on;
##}
