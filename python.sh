#!/bin/sh

## django project
python manage.py migrate
python manage.py createsuperuser

## requirements.txt
pip freeze > requirements.txt
pip install -r requirements.txt

## tuna
pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

## protobuf
protoc -I protobuf --python_out=protobuf protobuf/dy.proto

## pyinstaller
pyinstaller main.py
pyinstaller --onefile main.py
pyinstaller -F -w -i favicon.ico main.py

## pyenv
pyenv version # 查看当前系统的python版本
pyenv versions # 查看当前系统安装的python版本
pyenv install --list # 查看可以安装的python版本
pyenv install 3.11.4 # 安装python3.11.4版本
pyenv uninstall 3.11.4 # 卸载python3.11.4版本
pyenv local 3.11.4 # 在当前目录下创建一个.python-version文件，内容为3.11.4，表示当前目录下的python版本为3.11.4
pyenv global 3.11.4 # 设置全局python版本为3.11.4
pyenv shell 3.11.4 # 设置当前shell的python版本为3.11.4
