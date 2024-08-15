#!/bin/sh

remote_host=
remote_user="root"
remote_port="22"
ssh_key=~/.ssh/id_rsa

showHelp() {
  echo "Usage: sh ./inst.sh [OPTIONS]"
  echo "Options:"
  echo "  -h <ssh host>"
  echo "  -p <ssh port>"
  echo "  -u <ssh user>"
  exit;
}

while getopts "h:p:u:" opt; do
  case "$opt" in
    h ) remote_host=$OPTARG ;;
    p ) remote_port=$OPTARG ;;
    u ) remote_user=$OPTARG ;;
    ? ) showHelp ;;
  esac
done


## install pyenv
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python-openssl git"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "git clone https://github.com/pyenv/pyenv.git ~/.pyenv"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "git clone https://gitee.com/wadde/pyenv.git ~/.pyenv"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export PYENV_ROOT=\"\$HOME/.pyenv\"' >> ~/.bashrc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export PATH=\"\$PYENV_ROOT/bin:\$PATH\"' >> ~/.bashrc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'eval \"\$(pyenv init --path)\"' >> ~/.bashrc"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'eval \"\$(pyenv init -)\"' >> ~/.bashrc"
