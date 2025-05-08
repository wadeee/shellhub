## >>> conda initialize >>>
## !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/root/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/root/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/root/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/root/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
## <<< conda initialize <<<

if [ -d "/usr/local/cuda/bin" ]; then
    export PATH=$PATH:/usr/local/cuda/bin
fi

if [ -d "/usr/local/cuda/lib64" ]; then
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
    # Or you can add it to /etc/ld.so.conf and run ldconfig as root:
    # echo "/usr/local/cuda-12.x/lib64" | sudo tee -a /etc/ld.so.conf
    # sudo ldconfig
fi

if [ -d "/usr/local/cuda" ]; then
    export CUDA_PATH=$CUDA_PATH:/usr/local/cuda
fi

conda activate ktransformers

export TORCH_CUDA_ARCH_LIST="8.6"

export CUDA_LAUNCH_BLOCKING=1

export USE_NUMA=2
