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

### add proxy
#scp -P "$remote_port" -i $ssh_key ./config/proxy.sh "$remote_user"@"$remote_host":/etc/profile.d/
#
### ffmpeg
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /workspace"
#scp -P "$remote_port" -i $ssh_key ./ffmpeg-master-latest-linux64-gpl-shared.tar.xz "$remote_user"@"$remote_host":/root/
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "tar -xvf /root/ffmpeg-master-latest-linux64-gpl-shared.tar.xz -C /workspace"
#
### onnx
#scp -P "$remote_port" -i $ssh_key ./onnxruntime-linux-x64-1.14.0.tgz "$remote_user"@"$remote_host":/root/
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "tar -xvf /root/onnxruntime-linux-x64-1.14.0.tgz -C /workspace"
#
### git clone
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /etc/profile.d/proxy.sh && proxy_on && cd /workspace && git clone https://github.com/modelscope/FunASR.git"
#
### apt install
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt update"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "apt install libopenblas-dev libssl-dev cmake g++ -y"
#
### make
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "mkdir -p /workspace/FunASR/runtime/websocket/build"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "cd /workspace/FunASR/runtime/websocket/build && cmake -DCMAKE_BUILD_TYPE=release .. -DONNXRUNTIME_DIR=/workspace/onnxruntime-linux-x64-1.14.0 -DFFMPEG_DIR=/workspace/ffmpeg-master-latest-linux64-gpl-shared && make -j 4"

## install conda
#scp -P "$remote_port" -i $ssh_key ./Anaconda3-2025.06-1-Linux-x86_64.sh "$remote_user"@"$remote_host":/root/
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "bash Anaconda3-2025.06-1-Linux-x86_64.sh"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "/root/anaconda3/bin/conda init"
#ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "/root/anaconda3/bin/conda create --name funasr python=3.11 -y"

## pip install
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /root/anaconda3/etc/profile.d/conda.sh && conda activate funasr && source /etc/profile.d/proxy.sh && proxy_on && pip install torch torchaudio humanfriendly"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "source /root/anaconda3/etc/profile.d/conda.sh && conda activate funasr && source /etc/profile.d/proxy.sh && proxy_on && pip install -U funasr"

## upload service
scp -P "$remote_port" -i $ssh_key ./config/funasr.service "$remote_user"@"$remote_host":/usr/lib/systemd/system/
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl daemon-reload"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl enable funasr"
ssh -p "$remote_port" -i $ssh_key "$remote_user"@"$remote_host" "systemctl restart funasr"
