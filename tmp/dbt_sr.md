# init

```shell
# 这里不能用exec临时切环境, 有点诡异
pyenv global 3.10.12 
pyenv virtualenv dbt_sr_mrr
pyenv activate dbt_sr_mrr
pip install dbt-core dbt-starrocks
```

## 创建 profile
vim ~/.dbt/profiles.yml

dbt debug

dbt deps

dbt docs generate

nohup dbt docs serve 2>&1 > docs_nohup.log 2>&1 &

pip install dagster dagster-webserver pandas dagster-dbt

dagster-dbt project scaffold --project-name mrr_playbook_dagster

cd mrr_playbook_dagster

export DAGSTER_DBT_PARSE_PROJECT_ON_LOAD=1
nohup dagster dev 2>&1 > dagster_nohup.log 2>&1 &
