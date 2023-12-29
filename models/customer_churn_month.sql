with mrr as (
    select * from {{ ref('customer_revenue_by_month') }}
),
joined as (
    select
        {{ dbt.dateadd('month', "1", 'date_month') }} as date_month,
        customer_id,
        cast(0 as float) as mrr,
        false as is_active,
        first_active_month,
        last_active_month,
        false as is_first_month,
        false as is_last_month
    from mrr
    where is_last_month
)
select * from joined
