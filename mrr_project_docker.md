# 一次运行
- 本地切换成生产连接, dbt run 运行

如果是包含dbt上下游, 通过dagster调度触发
- 本地修改的 aseert 如何热更新到 dagster 生产环境?
- dagster api


# 日常调度
dagster 配置 schedule


# 快速调试:
- vscode 远程打开项目调试
- 要求将项目代码映射出来?


# 本地开发(windows/wsl2/docker/remote_ssh_linux):
- install python, dbt, dbt_starrocks
- 创建项目(dbt init, git init); git clone/pull(创建分支);
- 开发, 调试, 测试
- git push, 提交 PR


# 部署
- 依赖: docker
- 依赖基础镜像:
    - ubuntu 基础工具包, git, python, sudo 权限
    - 下面依赖可以分开, 但是避免每次部署, 重复(pip)安装, 制作下镜像; 
        - 来源库更新问题, 通过重建基础镜像解决
        - 或者在启动脚本 patch
    - dagster, dbt, dbt_starrocks
    - bashrc 配置文件
- 获取配置文件
    - profile
    - workspace.yaml
- 尝试 docker-compose 包含下面两个服务    
- run mrr_project
    - 拉取代码, 执行启动命令
    - 运行 dbt docs 服务
    - 运行 dagster_api, 暴露dbt模型
- run dagster 服务
    - dagster webserver
    - dagster daemon


# 触发器:
- 监控 main 分支, 存在新的提交时, 触发action, 拉取代码, 运行测试, 部署到生产环境





# 制作镜像


## make base l3_image

docker build . --build-arg "HTTP_PROXY=http://10.11.23.14:7890"     --build-arg "HTTPS_PROXY=http://10.11.23.14:7890"     --build-arg "NO_PROXY=localhost,127.0.0.1,.example.com"     -t lf_image:0.0.1 -f l3_dockerfile

echo "l3 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

chown -R l3:l3 /opt/apps 

volume map 好像失败了

docker run -p 7000-7100:7000-7100 -v /opt/apps/docker_volume_map:/opt/apps/docker_volume_map --name l3_dev_v2 -it lf_image:0.0.1 bash
如果要使用 volume 卷, run时需要指定


export http_proxy=http://10.11.23.14:7890;
export https_proxy=http://10.11.23.14:7890;

容器间如何访问:
- https://www.cnblogs.com/shenh/p/9714547.html

端口也要手动指定映射
- 启动dagster-server时, 先 unset 掉 http[s]_proxy


## 包含 python 相关库的基础镜像
cd /opt/apps/mrr-playbook;
docker build . --build-arg "HTTP_PROXY=http://10.11.23.14:7890"     --build-arg "HTTPS_PROXY=http://10.11.23.14:7890"     --build-arg "NO_PROXY=localhost,127.0.0.1,.example.com"     -t dbt_sr_dagster:0.0.1 -f l3_dockerfile


怎么初始化? 将配置映射进去, 通过挂载
- 缺点:k 要起dockerfile, 能直接用run命令测试么? 
- 然后执行初始化脚本
    - 从挂载拿到配置, 拷贝到指定位置
    - 执行起服务的操作


## dbt_sr_image:0.0.1
docker build . --build-arg "HTTP_PROXY=http://10.11.23.14:7890"     --build-arg "HTTPS_PROXY=http://10.11.23.14:7890"     --build-arg "NO_PROXY=localhost,127.0.0.1,.example.com"     -t dbt_sr_image:0.0.1 -f dbt_sr_dockerfile

与docker run 不同，Dockerfile中不能指定宿主机目录，默认使用docker管理的挂载点;
- 如果想实现动态加载配置, 如何搞?
    - docker-compoe 可以指定
- 常见操作都是从当前目录获取resource, 然后运行
    - git 等操作还是放在ci/cd机器上出触发

[] 子命令不能生效
[] dockerfile 显得有点复杂, 里面权限也有点乱


docker run -p 7010:7010 -p 7080:7080 --name mrr_project -itd dbt_sr_image:0.0.1

## FYI
docker dagster dbt: https://juangesino.medium.com/setup-dbt-using-docker-7b39df6c6af4


使用dockerfile的缺陷, 尝试docker-compose
- 环境变量使用文件麻烦
- 不能识别镜像名称找到, 需要在配置写死ip; 或者加入到同一网络



## dagster web
cd /opt/apps/mrr-playbook/tmp/dagster;
docker build . --build-arg "HTTP_PROXY=http://10.11.23.14:7890"     --build-arg "HTTPS_PROXY=http://10.11.23.14:7890"     --build-arg "NO_PROXY=localhost,127.0.0.1,.example.com"  -t dagster_web:0.0.1 -f dagster_web_dockerfile


docker run -p 3010:3010 --name dagster_web -itd dagster_web:0.0.1

[] 如何访问 mrr_project 镜像? 
[] 代理问题, 需要手动 unset 掉 proxy
[] 界面无法看到dbt run stdout 
 -  拿不到 capturedLogs 信息



# docker_compose.yaml
docker-compose build \
    --build-arg http_proxy=http://10.11.23.14:7890 \
    --build-arg https_proxy=http://10.11.23.14:7890


可以手动将image加入到网络中, 让他能识别[域名]
docker network connect mrr-playbook_default mrr_project


[] Unable to locate credentials
有一个无法访问具体凭证信息的BUG, 暂时先忽略
需要本地模拟s3
- https://docs.dagster.io/deployment/guides/kubernetes/deploying-with-helm
