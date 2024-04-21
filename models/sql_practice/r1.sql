-- 统计每个用户最早下单的订单ID; 多个订单取ID最小, u_id asc
select distinct
    u_id  
    ,first_value(order_id) over(partition by u_id order by order_date, order_id) as first_order_id
from cust_order_pkg_df
order by 1
;

{# 
-- v2
select u_id, order_id 
from (
select 
    u_id  
    ,order_id
    ,row_number() over(partition by u_id order by order_date, order_id) as rn
from cust_order_pkg_df
) t1 
where rn=1
order by 1 
#}
