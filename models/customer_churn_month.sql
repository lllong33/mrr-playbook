with mrr as (

    select * from {{ ref('customer_revenue_by_month') }}

),

-- row for month *after* last month of activity
joined as (

    select
        (date_month + INTERVAL '1 month')::date as date_month,
        -- dateadd(month, 1, date_month)::date as date_month,
        customer_id,
        0::float as mrr,
        false as is_active,
        first_active_month,
        last_active_month,
        false as is_first_month,
        false as is_last_month

    from mrr

    where is_last_month

)

select * from joined
