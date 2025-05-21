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

## install nvm ##
#scp -P "$remote_port" -i $ssh_key ./install.sh "$remote_user"@"$remote_host":/root/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /etc/profile.d/proxy.sh && proxy_on && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "bash ./install.sh"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo 'export NVM_DIR=\"\$HOME/.nvm\"' >> ~/.bashrc"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo '[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"' >> ~/.bashrc"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "echo '[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"' >> ~/.bashrc"

#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
