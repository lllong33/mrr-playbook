

[] 一键部署 mrr_project in docker
技术栈:
- python, dbt, dagster webserver
    [] dagster 单独部署
- starrocks
- superset

# python, dbt, dagster, init_env
编写 dockerfile
python==3.11.7
git clone mrr_project
os: ubuntu, 暂时用python=3.11.7默认版本;

## 1. docker run 方式启动
```shell
sudo docker run --name py311 \
    -v /opt/apps/mrr-playbook:/opt/apps/mrr-playbook \
    -v /home/l3/.dbt/profiles.yml:/root/.dbt/profiles.yml \
    -e http_proxy=http://10.11.37.22:7890 -e https_proxy=http://10.11.37.22:7890 \
    -p 8080:8080 -p 3000:3000 \
    -itd python:3.11.7 bash
```

## 2. dockerfile 方式启动
[] profiles.yml 后续用测试库替换
根据dockerfile启动镜像
sudo docker build -t mrr_project:0.0.1 .
sudo docker images 
sudo docker run -itd -p 8080:8080 -p 3000:3000 mrr_project:0.0.1
sudo docker ps -a | grep mrr_project:0.0.1


dagster deploy
```shell
pip install dagster dagster-webserver pandas dagster-dbt
dagster-dbt project scaffold --project-name mrr_playbook_dagster # directory in dbt_project.yml
cd mrr_playbook_dagster
export DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1
nohup dagster dev -h 0.0.0.0 2>&1 > dagster_dev.log 2>&1 &
tail -200f dagster_dev.log
```

dockerfile 有几种启动方式, 暂时用脚本方式


## 3.docker-compose 方式
[] github action 自动生产 mrr_project dbt相关镜像, 然后docker-compose只需要拉取就行;


回忆:
- docker run 启动一个容器
- dockerfile 如何启动呢? 
    之前都是用的这种方式, 分批制作镜像
- docker-compose 可以批量启动服务
    - 肯定希望这种方式



用法:
docker-compose up -d






















