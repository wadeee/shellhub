#!/bin/sh

## reset password
/usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic -i

## install plugin analysis-ik
/usr/share/elasticsearch/bin/elasticsearch-plugin install https://get.infini.cloud/elasticsearch/analysis-ik/8.17.2

## get users
curl -u elastic:$ELASTIC_PASSWORD \
  -X GET "http://localhost:9200/_security/user?pretty" \
  -H "Content-Type: application/json"

## add kibana_admin user
curl -u elastic:$ELASTIC_PASSWORD \
  -X POST "http://localhost:9200/_security/user/kibana_admin?pretty" \
  -H "Content-Type: application/json" \
  -d '{
    "password": "password",
    "roles": ["superuser", "kibana_admin"],
    "full_name": "Kibana Admin"
  }'

## modify kibana_system user
curl -u elastic:$ELASTIC_PASSWORD \
  -X PUT "http://localhost:9200/_security/user/kibana_system/_password?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "password": "password"
  }'

## get infos
curl -u elastic:$ELASTIC_PASSWORD localhost:9200

## add mappings
curl -u elastic:$ELASTIC_PASSWORD \
  -X PUT 'localhost:9200/temp?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "mappings": {
      "properties": {
        "user": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        },
        "title": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        },
        "desc": {
          "type": "text",
          "analyzer": "ik_max_word",
          "search_analyzer": "ik_max_word"
        }
      }
    }
  }'

## add
curl -u elastic:$ELASTIC_PASSWORD \
  -X POST 'localhost:9200/temp/_doc?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "user": "张三",
    "title": "工程师",
    "desc": "软件编程"
  }'

## multiple add
curl -u elastic:$ELASTIC_PASSWORD \
  -X POST 'localhost:9200/_bulk?pretty' \
  -H 'Content-Type: application/json' \
  -d '{ "index": { "_index": "tempp" } }
  { "user": "张三", "title": "软件工程师", "desc": "全栈开发" }
  { "index": { "_index": "tempp" } }
  { "user": "李斯", "title": "软件工程师", "desc": "全栈开发" }
  { "index": { "_index": "temp" } }
  { "user": "王五", "title": "测试工程师", "desc": "自动化测试" }
  { "index": { "_index": "temp" } }
  { "user": "李斯", "title": "软件工程师", "desc": "全栈开发" }
'

## modify
curl -u elastic:$ELASTIC_PASSWORD \
  -X PUT 'localhost:9200/temp/_doc/7j_ZO5UBDCgri9227A6B?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "user": "李四",
    "title": "高级工程师",
    "desc": "软件架构设计"
  }'

## get amounts
curl -u elastic:$ELASTIC_PASSWORD -X GET 'localhost:9200/temp/_count'

## search all
curl -u elastic:$ELASTIC_PASSWORD \
  -X POST 'localhost:9200/pdf-test1/_search?pretty' \
  -H 'Content-Type: application/json'

## search
curl -u elastic:$ELASTIC_PASSWORD \
  -X POST 'localhost:9200/temp/_search?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "query" : {
      "match" : {
        "desc" : "软件"
      }
    },
    "highlight" : {
      "pre_tags" : ["<tag1>", "<tag2>"],
      "post_tags" : ["</tag1>", "</tag2>"],
      "fields" : {
          "title" : {},
          "desc" : {}
      }
    }
  }'

## get plugin list
#/usr/share/elasticsearch/bin/elasticsearch-plugin list

## add pdf pipeline
curl -u elastic:$ELASTIC_PASSWORD \
  -X PUT "http://localhost:9200/_ingest/pipeline/attachment-pipeline?pretty" \
  -H 'Content-Type: application/json' \
  -d '{
    "description": "Extracts attachment metadata",
    "processors": [
      {
        "attachment": {
          "field": "data",
          "target_field": "pdf_infos",
          "indexed_chars": -1
        }
      },
      {
       "remove": {
         "field": "data"
       }
      },
      {
       "set": {
         "field": "pdf_infos.language",
         "value": "zh"
       }
      }
    ]
  }'

## delete pdf pipeline
curl -u elastic:$ELASTIC_PASSWORD \
  -X DELETE "http://localhost:9200/_ingest/pipeline/attachment-pipeline"

## get all pipelines
curl -u elastic:$ELASTIC_PASSWORD \
  -X GET "http://localhost:9200/_ingest/pipeline?pretty"

## pdf store
encodedPdf=`cat /root/sample.pdf | base64`
json="{\"data\":\"${encodedPdf}\"}"
echo "$json" > json.file
curl -u elastic:$ELASTIC_PASSWORD -X POST 'http://localhost:9200/pdf-test1/_doc?pipeline=attachment-pipeline&pretty' -H 'Content-Type: application/json' -d @json.file

## search object content
curl -u elastic:$ELASTIC_PASSWORD \
  -X POST 'localhost:9200/pdf-test1/_search?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
    "query" : {
      "match" : {
        "pdf_infos.content" : "天"
      }
    }
  }'
