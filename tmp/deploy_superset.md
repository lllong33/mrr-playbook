
# docker安装
docker-compose version
git clone https://github.com/apache/superset.git
sudo docker-compose up -d 
默认: admin/admin
8000

查看日志
sudo docker-compose logs -f
指定查看 superset_websocket 的日志
sudo docker-compose logs -f superset_websocket

superset_websocket服务无法起来, 日志显示 
WARN[0000] The "CYPRESS_CONFIG" variable is not set. Defaulting to a blank string.
WARN[0000] The "SCARF_ANALYTICS" variable is not set. Defaulting to a blank string.
WARN[0000] The "CYPRESS_CONFIG" variable is not set. Defaulting to a blank string.

## 问题1: superset 登录后访问不到静态静态资源;

export CYPRESS_CONFIG="DBH2maXwkemf0P+k/qzk6dUriYRp+jZSFb10avGuHydHNFZxzw49R/uY"

Unable to load SQLAlchemy dialect <class 'pydruid.db.sqlalchemy.DruidHTTPSDialect'>: No module named 'google'

尝试更改YMAL文件, 成功!

FYI: https://github.com/apache/superset/issues/26170



# dashboard

[x] 连接 sr
根据模板创建指标和看板
通过other选项中的 SQLAIchemy 连接
starrocks://<User>:<Password>@<Host>:<Port>/<Catalog>.<Database>
starrocks://jack:l3%40123@10.11.133.14:9030/default_catalog.mrr_playbook
show catalogs, 无法用power dbt执行

使用'%40'来表示@符号

An error occurred while fetching databases: Invalid decryption key
验证dockeer app镜像能访问本地sr, telnet没问题

尝试下非@符号的连接
starrocks://jack_v2:123456@10.11.133.14:9030/default_catalog.mrr_playbook

test conn 能验证密码没问题, 现在是清单无法获取, 应该是superset问题; 看IS是要用 docker-compose-non-dev.yml 文件, 但是就是用的这个;

Invalid decryption key in get_database, test_conn success


UnicodeDecodeError: 'utf-8' codec can't decode byte 0xfe in position 0: invalid start byte
Invalid decryption key

删除卷信息, 重建解决问题, 应该是有历史key导致, https://github.com/apache/superset/issues/8538#issuecomment-1073039913

## 修改语言
FYI: https://github.com/apache/superset/discussions/18806
superset/docker/pythonpath_dev/superset_config.py 文件中添加下面配置
LANGUAGES = {
    'en': {'flag': 'us', 'name': 'English'},
    'fr': {'flag': 'fr', 'name': 'French'},
    'zh': {'flag': 'cn', 'name': 'Chinese'},
}


## 编辑dashboard

### Current Customers
在sql工具箱中可以看到具体执行sql

数字和趋势线, 同环比, 要用高级分析
x-axis: date_month
时间粒度: month

设置
滞后比较: 1; 表示与前一个月对比, 即环比:(本月-上月)/上月
比较后缀: MoM; 用来表示指标 

高级分析
滚动窗口: 默认累计值cumsum
周期: 1; 定义滚动窗口函数的大小，相对于所选的时间粒度
最小周期: 显示值所需的滚动周期的最小值。例如，如果您想累积 7 天的总额，您可能希望您的“最小周期”为 7，以便显示的所有数据点都是 7 个区间的总和。这将隐藏掉前 7 个阶段的“加速”效果

重新采样:
这里应该是sample显示的数据
规则: Pandas 重新采样的规则
填充方式: 

### Current MRR
复制上个数据集; 使用save as 
MRR 指标定义: 

重新阅读:
https://www.getdbt.com/blog/modeling-subscription-revenue

分析流失、升级和降级等指标
即使您的续订存在季节性，您的订户群的健康状况也如此（因为您的收入是按月摊销的）
收入来源发生变化：新客户(NEW)、升级(UPGRADE)、降级(DOWNGRADE)、流失(CHURN)或重新激活(REACTIVATION)
客户的价值基于给定用户持续向您付款的时间：客户终身价值、平均合同价值
Monthly Recurring Revenue (MRR) analysis 每月经常性收入分析; 这里Recurring怎么定义的, new(0->55), upgrade(55->70), downgrade(70->0)都用新值


CHURNED CUSTOMERS NEGATIVE(流失客户消极): negative单词在这里的作用? 

ARPU: ARPPU (Average Revenue per paying user): 平均每付费用户收入
ARPAU (Average Revenue per active user): 平均每活跃用户收入
ARPA: Average Revenue per Account: 平均每账户收入 

ARPA MOM percentage change 百分比变化

### MRR_CUSTOMER_tendency
高级分析: Mixed Chart
难点: MRR和customer使用相同了相同Y纵坐标
- 在定制化配置中, Y轴: 主要, 次要的; 区分左右轴

这个字段的作用: 
Dimensions: Dimensions contain qualitative values such as names, dates, or geographical data. Use dimensions to categorize, segment, and reveal the details in your data. Dimensions affect the level of detail in the view.
维度包含定性值，如名称、日期或地理数据。使用维度对数据进行分类、分段和显示细节。维度影响视图中的细节级别。

### Revenue Changes
新客户(NEW)、升级(UPGRADE)、降级(DOWNGRADE)、流失(CHURN)或重新激活(REACTIVATION)
图形选择: 条形图; 图标选项 -> 堆积样式 -> Stack
指标: downgrade, churn 通过case when 判断成负数; 需要 is_activate = False, filter null

dashboard怎么新增行? 


### Customer Count Changes
仅看new, upgrade, reactivetion;
如何显示在中间并且是圆形? 
- 图表选项, 图示; ORIENTATION(Legend Orientation仅四个方向) 没有顶部中间选择
- 也没有图形格式,  
- TODO 没找到相关配置


### ARPA
ARPA: Average Revenue per Account: 平均每账户收入 
每月 sum(mrr)/count(distinct customer_id), 放在第二个趋势图里面,但是纵坐标不好看, 无法看趋势了, 而且关联性不大.

The color scheme is determined by the related dashboard. Edit the color scheme in the dashboard properties.
配色方案由相关的仪表板决定。编辑仪表板属性中的配色方案。
线条样式: 改成 smooth line, 没有生效, 不能改成平滑的线条.


# dashboard导出与查看
[] 存在格式问题, 全铺平太丑, 到处jpg/pdf不太好看;
    [] 查看方式
    [] 报表不能填充满, 或者说显示不好看; 



