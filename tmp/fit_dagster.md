参考: https://www.notion.so/Dagster-dbt-duckdb-api-734ecdfb69204f478f7699862cf7e9f4#03928027afe544e79c8d41b0b685faf6

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
    迁移到node1节点, 是否用docker运行? 暂时不搞复杂了
    配置git config信息
git config --list | grep email
git config --global user.email lllong33new@gmail.com


[] dagster 生产部署方式
    [] web端需要单独部署

[] TODO SR-PR 添加 concat macro, 默认走的pg || 

[] 运维和监控

[] 告警; 当dbt test执行失败时, 发送邮件;





