#!/bin/sh

apt update
apt upgrade -y
apt-get install build-essential gcc make linux-headers-$(uname -r) -y
cp /home/cellxserver/NVIDIA-Linux-x86_64-535.161.07-grid.run /root/
chmod +x /root/NVIDIA-Linux-x86_64-535.161.07-grid.run
lsmod | grep nouveau
vi /etc/modprobe.d/blacklist-nouveau.conf
########## input
## blacklist nouveau
## options nouveau modeset=0
##########
update-initramfs -u
lsmod | grep nouveau
/root/NVIDIA-Linux-x86_64-535.161.07-grid.run
reboot
nvidia-smi

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt-get update
apt-get -y install cuda-toolkit-12-8
# apt-get install -y nvidia-open
apt-get install -y cuda-drivers

vi ~/.bashrc
## Adding CUDA to PATH
#if [ -d "/usr/local/cuda/bin" ]; then
#    export PATH=$PATH:/usr/local/cuda/bin
#fi
#
#if [ -d "/usr/local/cuda/lib64" ]; then
#    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
#    # Or you can add it to /etc/ld.so.conf and run ldconfig as root:
#    # echo "/usr/local/cuda-12.x/lib64" | sudo tee -a /etc/ld.so.conf
#    # sudo ldconfig
#fi
#
#if [ -d "/usr/local/cuda" ]; then
#    export CUDA_PATH=$CUDA_PATH:/usr/local/cuda
#fi

apt-get install build-essential cmake ninja-build -y

apt install -y git

wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
bash Anaconda3-2024.10-1-Linux-x86_64.sh
~/anaconda3/bin/conda init

conda create --name ktransformers python=3.11
conda activate ktransformers
conda install -c conda-forge libstdcxx-ng
strings ~/anaconda3/envs/ktransformers/lib/libstdc++.so.6 | grep GLIBCXX

pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
pip3 install torch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 --index-url https://download.pytorch.org/whl/cu122
pip3 install packaging ninja cpufeature numpy

## upload file flash_attn-2.7.4.post1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl
pip3 install flash_attn-2.7.4.post1+cu12torch2.6cxx11abiTRUE-cp311-cp311-linux_x86_64.whl

git clone https://github.com/kvcache-ai/ktransformers.git
cd ktransformers
git submodule init
git submodule update


# sudo apt-get remove nodejs npm -y && sudo apt-get autoremove -y
sudo apt-get update -y && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource.gpg
sudo chmod 644 /usr/share/keyrings/nodesource.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_23.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update -y
sudo apt-get install nodejs -y

cd ktransformers/website
npm install @vue/cli
npm run build
cd ../../
pip install .

bash install.sh

## install python3.11
add-apt-repository ppa:deadsnakes/ppa -y
apt update
apt install python3.11 -y
update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
update-alternatives --config python3
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py


## install nvidia
ubuntu-drivers autoinstall


#numactl -N 1 -m 1 python ./ktransformers/local_chat.py --model_path /root/DeepSeek-R1-GGUF --gguf_path /root/DeepSeek-R1-GGUF/DeepSeek-R1-Q4_K_M  --cpu_infer 33 --max_new_tokens 1000
#numactl -N 1 -m 1 python -m ktransformers.local_chat --model_path deepseek-ai/DeepSeek-V2-Lite-Chat --gguf_path ./DeepSeek-V2-Lite-Chat-GGUF --cpu_infer 33 --max_new_tokens 1000
#numactl -N 1 -m 1 python -m ktransformers.local_chat --model_path ./DeepSeek-V2-Lite --gguf_path ./DeepSeek-V2-Lite-Chat-GGUF --cpu_infer 33 --max_new_tokens 1000
numactl -N 1 -m 1 python -m ktransformers.local_chat --model_path ./DeepSeek-V2-Lite --gguf_path ./DeepSeek-V2-Lite-Chat-GGUF --cpu_infer 0 --max_new_tokens 1000
numactl -N 1 -m 1 python /root/ktransformers/ktransformers/local_chat.py --model_path /root/DeepSeek-V2-Lite/ --gguf_path /root/DeepSeek-V2-Lite-Chat-GGUF --optimize_config_path /root/ktransformers/ktransformers/optimize/optimize_rules/DeepSeek-V2-Lite-Chat.yaml --cpu_infer 48 --max_new_tokens 1000
python /root/ktransformers/ktransformers/local_chat.py --model_path /root/DeepSeek-V2-Lite-Chat/ --gguf_path /root/DeepSeek-V2-Lite-Chat-GGUF --optimize_config_path /root/ktransformers/ktransformers/optimize/optimize_rules/wade.yaml --cpu_infer 48 --max_new_tokens 1000
python /root/ktransformers/ktransformers/local_chat.py --model_path deepseek-ai/DeepSeek-V2-Lite-Chat --gguf_path /root/DeepSeek-V2-Lite-Chat-GGUF --optimize_config_path /root/ktransformers/ktransformers/optimize/optimize_rules/wade.yaml --cpu_infer 48 --max_new_tokens 1000
python /root/ktransformers/ktransformers/local_chat.py --model_path /root/DeepSeek-V2-Lite/ --gguf_path /root/DeepSeek-V2-Lite-GGUF --optimize_config_path /root/ktransformers/ktransformers/optimize/optimize_rules/wade.yaml --cpu_infer 46 --max_new_tokens 1000
python /root/ktransformers/ktransformers/local_chat.py --model_path /root/DeepSeek-V2-Lite/ --gguf_path /root/DeepSeek-V2-Lite-GGUF --optimize_config_path /root/ktransformers/ktransformers/optimize/optimize_rules/DeepSeek-V2-Lite-Chat.yaml --cpu_infer 46 --max_new_tokens 1000


numactl -N 1 -m 1 python /root/ktransformers/ktransformers/local_chat.py --model_path /root/DeepSeek-V2-Lite/ --gguf_path /root/DeepSeek-V2-Lite-GGUF --optimize_config_path /root/ktransformers/ktransformers/optimize/optimize_rules/DeepSeek-V2-Lite-Chat.yaml --cpu_infer 46 --max_new_tokens 1000

python /root/ktransformers/ktransformers/local_chat.py --model_path /root/DeepSeek-V2-Lite/ --gguf_path /root/DeepSeek-V2-Lite-GGUF --optimize_config_path /root/ktransformers/ktransformers/optimize/optimize_rules/DeepSeek-V2-Lite-Chat.yaml --cpu_infer 46 --max_new_tokens 1000

#Ktransformers+DeepSeek安装
#sudo apt update
#sudo apt upgrade -y
#sudo apt install gcc -y
#sudo apt install build-essential cmake ninja-build -y
#reboot
#//下载NVIDIA-Linux-x86_64-535.161.07-grid.run至ubuntu
#chmod +x NVIDIA-Linux-x86_64-535.161.07-grid.run
#sudo ./NVIDIA-Linux-x86_64-535.161.07-grid.run
#sudo reboot
#nvidia-smi
## 下载并安装CUDA 12.4的仓库描述文件
#sudo apt-get update
#sudo apt-get install -y wget gnupg
#wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
#sudo dpkg -i cuda-keyring_1.1-1_all.deb
#sudo apt-get -y install cuda-toolkit-12-4
#echo 'export PATH=/usr/local/cuda/bin:$PATH' >> ~/.bashrc
#echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
#source ~/.bashrc
#//安装Anaconda
#wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
#bash Anaconda3-2024.10-1-Linux-x86_64.sh
#echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
#source ~/.bashrc
#sudo reboot
#conda update conda -y
#conda install libgcc -y
#conda install -c conda-forge libstdcxx-ng -y
#conda init
#sudo reboot
#conda create --name ktransformers python=3.11 -y
#//退出 conda deactivate
#conda activate ktransformers
#
#
#pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
#pip install flash-attn
#pip install --no-cache-dir ktransformers
#
#
#mkdir DeepSeek-V2-Lite-Chat-GGUF
#cd DeepSeek-V2-Lite-Chat-GGUF
#
#
#wget https://huggingface.co/mradermacher/DeepSeek-V2-Lite-GGUF/resolve/main/DeepSeek-V2-Lite.Q4_K_M.gguf -O DeepSeek-V2-Lite-Chat.Q4_K_M.gguf
#
#
#ktransformers --model_path deepseek-ai/DeepSeek-V2-Lite-Chat --gguf_path $(pwd) --port 10002 --web True

