-- 求 2021-10-21日下单用户在第五天, 第7天的回购比例;
-- ex1: 2021-10-21 为第0天, 22为第1天
-- 输出: days, buyback_ratio

-- self join, 可以算出相差天数 diff_dt
with t1 as (
    -- pk
    select 
        u_id, order_date
    from cust_order_pkg_df
    group by 1,2 
)
, t2 as (
select 
    t1.u_id
    ,datediff(t2.order_date, t1.order_date) as dt_diff  
    ,count(1) over() as u_cnt
from t1
left join t1 as t2 
    on t1.u_id = t2.u_id 
    and datediff(t2.order_date, t1.order_date) in (5, 7)
where t1.order_date='2021-10-21' -- 这里有坑
)

select 
    dt_diff
    ,sum(if(dt_diff=5, 1, 0))/max(u_cnt) as 5_ratio
    ,sum(if(dt_diff=7, 1, 0))/max(u_cnt) as 7_ratio
from t2 

group by 1 

