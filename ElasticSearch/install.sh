#!/bin/sh

## reset password
/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -i

## add kibana_admin user
curl -u elastic:$ELASTIC_PASSWORD \
  -X POST "http://localhost:9200/_security/user/kibana_admin" \
  -H "Content-Type: application/json" \
  -d '{
    "password": "password",
    "roles": ["superuser", "kibana_admin"],
    "full_name": "Kibana Admin"
  }'

## modify kibana_system user
curl -u elastic:$ELASTIC_PASSWORD \
  -X PUT "http://localhost:9200/_security/user/kibana_system/_password" \
  -H 'Content-Type: application/json' \
  -d '{
    "password": "password"
  }'

## restart kibana
systemctl restart kibana
