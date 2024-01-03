参考: https://www.notion.so/Dagster-dbt-duckdb-api-734ecdfb69204f478f7699862cf7e9f4#03928027afe544e79c8d41b0b685faf6

# issue
目录有点诡异, 怎么是 mrr_playbook_dagster/mrr_playbook_dagster/__init__.py; 而第一层是setup.py脚本; 怎么理解? 

# 集成现有dbt项目
```shell
pip install dagster dagster-webserver pandas dagster-dbt
dagster-dbt project scaffold --project-name mrr_playbook_dagster # directory in dbt_project.yml
cd mrr_playbook_dagster
DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1 dagster dev
# Serving dagster-webserver on http://127.0.0.1:3000 in process 70635
```



# 配置调度
[x] 配置调度
创建 schedules 资源; 需要手动启动? 
之前状态和执行记录没了
```shell
export DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1
nohup dagster dev &
```


找不到 assert
[] 调度没有正常运行
    运行在ubuntu wsl2子系统中, 没有正常启动导致
    配置git config信息
git config --list | grep email
git config --global user.email lllong33new@gmail.com


[] dagster 生产部署方式
    [] web端需要单独部署

[] TODO SR-PR 添加 concat macro, 默认走的pg || 

[] 运维和监控

[] 告警; 当dbt test执行失败时, 发送邮件;

2024-01-02
调度在 wsl2 中没有正常运行, 需要统一部署到node1; 由于 node1 的 python 环境问题只能在docker中运行;

常用工具和命令
[] ll 命令


[] 2h-vscode不能识别docker中python环境; 需要映射出来; 
[x] 3000端口看见映射了, 但是不能访问; 
    [] 避免重复安装环境, 尝试dockerfile方式调试; 
    参考 https://stackoverflow.com/questions/39525820/docker-port-forwarding-not-working
    常见应用程序绑定了当前主机地址 [] 这里有点模糊两者原因
    export DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1
    nohup dagster dev -h 0.0.0.0 2>&1 > dagster_dev.log 2>&1 &


参考: https://www.restack.io/docs/dagster-knowledge-dagster-windows-service-integration
找到一种生产部署集成方式:
export DAGSTER_HOME=/opt/apps/mrr-playbook/mrr_playbook_dagster 
export DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1
nohup dagster-webserver -h 0.0.0.0 -p 3000 2>&1 > dagster_pro.log 2>&1 &

[x] dbt 关于 0.0.0.0 的问题, 暂时修改脚本将localhost改为0.0.0.0;
dbt docs serve --port 80
    参考: https://github.com/dbt-labs/dbt-core/blob/dev/guion-bluford/dbt/task/serve.py#L28
    参考: https://github.com/dbt-labs/dbt-core/issues/1045
关于 dbt docs serve 使用docker 部署: https://discourse.getdbt.com/t/publishing-dbt-docs-from-a-docker-container/141

撒花! 成功解决问题, 暂时可以不用尝试dockerfile!!!

[] git 如何管理问题; chmod修改代码权限发生变化; 

# dagster docker 部署方式
FYI: https://discuss.dagster.io/t/15991660/hello-i-am-looking-for-some-support-ive-dockerized-my-dagste



