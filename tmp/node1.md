[] high 使用dockerfile启动镜像, 避免很多重复操作;
[] high 制作基础系统镜像, 后续在这个基础上操作;


[] python环境不可用, _ctypes no module; 可能是 pyenv 和 ct7.8 问题.
[] 使用dockerfile, docker-compose
    https://docs.docker.com/language/python/containerize/
[] 制作镜像
[] 重新复习 docker 知识, 主要是解决node1环境问题;
    
端口参数: https://docs.docker.com/engine/reference/commandline/run/#publish
host_port:images_port



加了参数d, bash命令就不会进入了;
[x] 已存在的容器添加映射目录; 操作太麻烦, 而且要重启docker, 不建议 https://www.jianshu.com/p/8052fa5b1933
[x] 修改映射端口也一样麻烦; 还是推荐 dockerfile 方式;


sudo docker ps -a | grep py311

# 好像只能在启动时, 进入
sudo docker start py311

sudo docker exec -it py311 bash

sudo docker logs py311

需要配置实际ip的地址+port, 不能用node1;
export http_proxy=http://10.11.23.14:7890;
export https_proxy=http://10.11.23.14:7890;
删除 http_proxy 变量
unset http_proxy
unset https_proxy



apt-get update
apt-get install -y vim telnet

[] 容器用的root用户
[] 工作目录 mrr_project
[] 缺少别名 ll



# dockerfile

