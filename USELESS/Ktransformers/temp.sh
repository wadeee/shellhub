#!/bin/sh

vi /etc/ssh/sshd_config
## PermitRootLogin yes
systemctl restart sshd

apt update
apt upgrade -y

wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh
bash Anaconda3-2024.10-1-Linux-x86_64.sh
~/anaconda3/bin/conda init
source ~/.bashrc
conda create --name ktransformers python=3.11 -y
conda activate ktransformers
conda install -c conda-forge libstdcxx-ng
apt install build-essential gcc make linux-headers-$(uname -r) cmake ninja-build binutils git git-lfs -y
strings ~/anaconda3/envs/ktransformers/lib/libstdc++.so.6 | grep GLIBCXX

lsmod | grep nouveau
vi /etc/modprobe.d/blacklist-nouveau.conf
########## input
## blacklist nouveau
## options nouveau modeset=0
##########
update-initramfs -u
lsmod | grep nouveau
reboot

wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
apt update
apt -y install cuda nvidia-cuda-toolkit
#apt -y install cuda-toolkit-12-8
#apt install -y cuda-drivers

cp /home/cellxserver/NVIDIA-Linux-x86_64-535.161.07-grid.run /root/
chmod +x /root/NVIDIA-Linux-x86_64-535.161.07-grid.run
/root/NVIDIA-Linux-x86_64-535.161.07-grid.run
reboot
nvidia-smi

pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
pip3 install packaging ninja cpufeature numpy flash-attn

pip install ktransformers

git lfs install
git clone https://www.modelscope.cn/deepseek-ai/DeepSeek-V2.5.git


#python -m ktransformers.local_chat --model_path /root/DeepSeek-V2.5/ --gguf_path /root/DeepSeek-V2.5-GGUF/DeepSeek-V2.5-IQ4_XS/ --optimize_rule_path /root/optimize_rules/wade.yaml --cpu_infer 46 --max_new_tokens 1000
python -m ktransformers.local_chat --model_path /root/DeepSeek-V2.5/ --gguf_path /root/DeepSeek-V2.5-GGUF/DeepSeek-V2.5-IQ4_XS/ --optimize_rule_path /root/anaconda3/envs/ktransformers/lib/python3.11/site-packages/ktransformers/optimize/optimize_rules/DeepSeek-V2-Chat.yaml --cpu_infer 46 --max_new_tokens 1000
taskset -c 0-35 python -m ktransformers.local_chat --model_path /root/DeepSeek-V2.5/ --gguf_path /root/DeepSeek-V2.5-GGUF/DeepSeek-V2.5-IQ4_XS/ --optimize_rule_path /root/anaconda3/envs/ktransformers/lib/python3.11/site-packages/ktransformers/optimize/optimize_rules/DeepSeek-V2-Chat.yaml --cpu_infer 36 --max_new_tokens 1000


## uninstall
/root/NVIDIA-Linux-x86_64-535.161.07-grid.run --uninstall
rm -rf /etc/modprobe.d/nvidia.conf
rm -rf /etc/X11/xorg.conf
rm -rf /lib/modules/$(uname -r)/kernel/drivers/video/nvidia*
rm -rf /usr/lib/nvidia*
apt purge '^nvidia-.*' -y
apt purge '^libnvidia-.*' -y
apt purge '^cuda-.*' -y
apt purge '^libcuda.*' -y
apt purge '^cudnn.*' -y
rm -rf /usr/local/cuda*
rm -rf /etc/systemd/system/nvidia*
rm -rf /etc/modprobe.d/nvidia*
rm -rf /etc/X11/xorg.conf.d/10-nvidia*
rm -rf /var/lib/dkms/nvidia*
apt autoremove -y
apt autoclean
update-initramfs -u
reboot
