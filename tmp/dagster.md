参考: https://www.notion.so/Dagster-dbt-duckdb-api-734ecdfb69204f478f7699862cf7e9f4#03928027afe544e79c8d41b0b685faf6

# issue
目录有点诡异, 怎么是 mrr_playbook_dagster/mrr_playbook_dagster/__init__.py; 而第一层是setup.py脚本; 怎么理解? 

# 集成现有dbt项目
```shell
pip install dagster dagster-webserver pandas dagster-dbt
# 根据当前目录生成dagster项目
dagster-dbt project scaffold --project-name mrr_playbook_dagster # directory in dbt_project.yml
cd mrr_playbook_dagster
# 本地测试命令
DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1 dagster dev
# Serving dagster-webserver on http://127.0.0.1:3000 in process 70635
```

# dagster docker 部署方式

1. 开发模式:
- export DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1 && dagster dev

2. 本地部署方式:
- 启动 dagster web;
- deamon 管理调度等功能;

3. docker 部署方式:
- web
- daemon
- code location
- postgres 额外用来持久化数据
- docker-compose 方便管理

参考: 主要看官方文档
- https://github.com/dagster-io/dagster/tree/1.5.13/examples/deploy_docker
- https://docs.dagster.io/deployment/guides/docker


3. k8s(hlem)


## 组件和配置文件概念

### 关于 location code  
手动指定 workspace.yaml 指定

- from fiel
- from module 
- from pyproject.toml 

### storage, instance
开发模式, 执行记录直接存储在当前目录的临时文件中
指定 DAGSTER_HOME 持久化
- dagster.yaml 从该文件查找持久化配置
- 数据库配置等

### Dagster webserver
DAGSTER_HOME=/opt/dagster/dagster_home
dagster-webserver -h 0.0.0.0 -p 3000

### Dagster daemon 
using schedules, sensors, or backfills
DAGSTER_HOME=/opt/dagster/dagster_home
dagster-daemon run

需要能访问到配置文件, 已经相关组件

左侧导航栏中的“实例”选项卡, UI 中检查 dagster-daemon 进程的状态

只能有一个进程

### 手动测试部署下

pip install dagster-webserver dagster-postgres dagster-aws dagster-docker

export DAGSTER_HOME=/opt/apps/dagster_web

cp ../docker_volume_map/repo.py .
cp ../docker_volume_map/dagster.yaml .
cp ../docker_volume_map/workspace.yaml .

dagster-webserver -h 0.0.0.0 -p 7001

如何将新的 code location 加入到 dagster web 中
- 命令行标识
- 查看 workspace 文件文档 https://docs.dagster.io/concepts/code-locations/workspace-files
- 通过module方式
- 运行自己的 gRPC 服务

尝试使用grpc时, 会走 proxy 搜索, 导致找不到; 

dagster api grpc --working-directory /opt/apps/mrr-playbook/mrr_playbook_dagster --module-name mrr_playbook_dagster --host 0.0.0.0 --port 80
- 需要添加 pg 相关环境变量
- 将 definition 定义放到__init__.py文件, 来启动api grpc
- 无法查看具体 stdout 


