#!/bin/sh

## django project
python manage.py migrate
python manage.py createsuperuser

## requirements.txt
pip freeze > requirements.txt
pip install -r requirements.txt

## proto
protoc -I protobuf --python_out=protobuf protobuf/dy.proto
