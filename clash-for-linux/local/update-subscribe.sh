#!/bin/sh
curl -o /root/clash/clash_config.yaml http://172.105.209.249:8570/link/OnazBn0SUlTajZ4z?clash=1
mkdir -p /root/clash/conf
cp /root/clash/conf/config-origin.yaml /root/clash/conf/config.yaml
cp /root/clash/conf/Country-origin.mmdb /root/clash/conf/Country.mmdb
sed -n '/^proxies:/,$p' /root/clash/clash_config.yaml >> /root/clash/conf/config.yaml
systemctl restart clash
