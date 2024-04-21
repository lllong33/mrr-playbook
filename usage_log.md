
1. 尝试本地 wsl2 启动项目, 并梳理这个过程
docker-compose up 

check:
- dbt_project.yml profile
- profiles.yml db_info
- dbt debug 
- view docker-compose.yml
curl -v google.com

这个镜像需要自己重新根据 dockerfile 本地打一下
load metadata for docker.io/library/dbt_sr_dagster_image:0.0.1:
TODO 有难度, 且兴趣有限暂时搁置

2. 尝试梳理 MRR 表和数据流
seeds: 

--------- 2024-04-19

Core:
  - installed: 1.4.3
  - latest:    1.4.3 - Up to date!

Plugins:
  - postgres: 1.4.3 - Up to date!


需要 gui 查看 postgresql 数据
psql 常用命令

postgresql 也不支持 别名

# dbt_sr 

IS-1: not support int and str; sr version check bug

monthly recurring revenue (MRR)

IS-2 agate.table.Table object has no element 0
使用jack用户创建的临时表没有权限, 

[x] relation.sql 没做拿错视图异常的捕获, 当没拿到时返回上面报错

[x] IS-3 customer_revenue_by_month 创建视图后, 出现查 information_schema.views  报错 StarRocks process failed
- 暂时移除view改为table解决

dbt seed properties(yml):
```yaml
Complete configuration:
models:
  materialized: table       // table or view or materialized_view
  engine: 'OLAP'
  keys: ['id', 'name', 'some_date']
  table_type: 'PRIMARY'     // PRIMARY or DUPLICATE or UNIQUE
  distributed_by: ['id']
  buckets: 3                // default 10
  partition_by: ['some_date']
  partition_by_init: ["PARTITION p1 VALUES [('1971-01-01 00:00:00'), ('1991-01-01 00:00:00')),PARTITION p1972 VALUES [('1991-01-01 00:00:00'), ('1999-01-01 00:00:00'))"]
  properties: [{"replication_num":"1", "in_memory": "true"}]
  refresh_method: 'async' // only for materialized view default manual
```

dbt run config:
Example configuration:
```yaml
{{ config(materialized='view') }}
{{ config(materialized='table', engine='OLAP', buckets=32, distributed_by=['id']) }}
{{ config(materialized='incremental', table_type='PRIMARY', engine='OLAP', buckets=32, distributed_by=['id']) }}
{{ config(materialized='materialized_view') }}
{{ config(materialized='materialized_view', properties={"storage_medium":"SSD"}) }}
{{ config(materialized='materialized_view', refresh_method="ASYNC START('2022-09-01 10:00:00') EVERY (interval 1 day)") }}
For materialized view only support partition_by、buckets、distributed_by、properties、refresh_method configuration.
```

[] "replication_num" = "1" 怎么设置默认为3?

default_replication_num
fe.conf 
FE动态参数
ADMIN SHOW FRONTEND CONFIG like 'default_replication_num'
ADMIN SET FRONTEND CONFIG ("key" = "value");
查到看默认是3
临时表确实用副本=1更合适, 暂时只能每张表手动去配置   properties: '{"replication_num":"3"}'


# MRR(Monthly Recurring Revenue) 场景理解
订阅组件: 
分析流失、升级和降级等指标
了解您的订户群的健康状况

缺点:
- 源数据编写查询, 变得复杂, 逻辑重复.

use dbt 原因:
- 模型逻辑固定, 仅在来源转换(标准化)数据, 统一口径.
- 模型测试用例, 保证数据质量(符合预期)
- 支持业务adhoc

change_category: new, churn, upgrade, downgrade, reactivation
- 补全月份(date spining), 标注出 churn, upgrade 
- identify first and last active month 
  - is_last_month -> is_active
- generate churn month; 

```sql
case
  when is_first_month
      then 'new'
  when not(is_active) and previous_month_is_active
      then 'churn'
  when is_active and not(previous_month_is_active)
      then 'reactivation'
  when mrr_change > 0 then 'upgrade'
  when mrr_change < 0 then 'downgrade' end as change_category
```

ACME Monthly Recurring Revenue

## DashBoard module
ex: https://www.getdbt.com/ui/img/blog/modeling-subscription-revenue/Screen-Shot-2020-01-08-at-2.05.11-PM.png
- Current_Customers, MOM
- Current_MRR, MOM
- MRR and Customers, 近一年趋势图
- Revenue Changes: 组合图
    - churned_mrr, downgraded_mrr, upgraded_mrr, new_mrr, reactivated_mrr
- Customer Count Changes: 组合图
    - churned_customers_negative, new_customers, reactivated_customers
- ARPA(Average Revenue Per User 每个账户的平均收入) 近13个月趋势图



# 建模分析

1. 收集数据
- 格式化成标准数据, stg -> ods

2. 将拉链表打平, 并填补缺失值
ods -> dwd
难点, 填补逻辑即流失和重新激活, 如何定义?

3. 确定first and final activate month

IS 如何填补缺失值?


4. mrr type
is_first_month: new
not is_active and previous_month_is_active: churn
is_active and not previous_month_is_active: reactivated
mrr > 0: upgrade
mrr < 0: downgrade


TODO utils 代码如何查看, 暂时通过github search mutually_exclusive_ranges

tag: 数据质量, 容忍度/成本?
MRR 仪表板, 应该是用于了解业务健康状况, 而不是用于财务对账. 
虽然完美和解听起来是一件值得追求的好事, 但你最终会陷入困境, 试图找出 0.02 美元去向
建议您与利益相关者沟通, 让他们了解MRR场景, 确保对数字有容忍度




# docker superset 
```shell
git clone https://github.com/apache/superset.git
cd superset
docker-compose -f docker-compose-non-dev.yml up

# 通过文件配置
docker-compose-non-dev.yml
x-superset-depends-on
network_mode: host

postgresql://postgres:postgres@cdc_playgrounds-postgres-1:5432/postgres

http://localhost:8088
admin/admin

# optional: load examples & spent resource
SUPERSET_LOAD_EXAMPLES决定superset_init容器是否将示例数据和可视化加载到数据库和 Superset 中。
- 本地 Superset 实例还包括一个 Postgres 服务器来存储您的数据, 预加载了 Superset 附带的一些示例数据集

```

连接本地数据库
- 可以填写容器名称, 也可以填写ip地址; 注意localhost指代的superset容器地址



CREATE USER postgres WITH PASSWORD 'postgres';


GRANT ALL PRIVILEGES ON DATABASE postgres TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
GRANT ALL PRIVILEGES ON DATABASE PUBLIC TO postgres;


GRANT pg_read_all_data TO postgres;
GRANT pg_write_all_data TO postgres;


customize -> Query A -> Y AXIS -> Secondary


big number:
IS title top? 
IS mom 计算?
- 没有直接可用的 kpi 
- 试用下官方提供折线图环比图
time comparison
minus 1 week
time shift 
calculation type 
absolute difference 

postgre 计算同环比时, 除法取决分子类型保存小数位数

filter box: stat_mo 日期格式显示数字了

IS colos change?
