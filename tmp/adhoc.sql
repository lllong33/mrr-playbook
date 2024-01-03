
select * from {{ ref('mrr') }}


-- current customers
select count(distinct customer_id) from {{ ref('mrr') }}



