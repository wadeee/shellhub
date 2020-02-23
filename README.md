# OFTENSHELL

Run the shell easily when the system remounted.

## Docker下测试

+ 进入Dockerfile目录，构建image并查看镜像是否生成

    ```bash
    docker build -t oftenshell ./Dockerfile
    docker images
    ```

+ 生成并运行container

    ```bash
    docker run -itd --name=oftenshell --privileged oftenshell
    docker exec -it -w="/root/oftenshell" oftenshell bash
    ```

+ 使用完后删除image和container

    ```bash
    docker stop oftenshell && docker rm oftenshell && docker image rm oftenshell
    ```

## Install the git and clone

```shell script
dnf install -y git
git clone https://github.com/wadeee/oftenshell.git ~/oftenshell
# git clone git@github.com:wadeee/oftenshell.git ~/oftenshell
```
