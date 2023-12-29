{% macro starrocks__datediff(first_date, second_date, datepart) -%}

    -- DATE_DIFF(VARCHAR unit, DATETIME expr1, DATETIME expr2)
    -- unit：差值的时间单位，必填。unit 的取值必须是 year, quarter, month, week，day，hour，minute，second，millisecond。
    -- expr1，expr2：要进行比较的两个日期值，必填。支持的数据类型为 DATETIME 和 DATE。
    -- select date_diff('second', '2010-11-30 23:59:59', '2010-11-30 20:58:59');

    -- https://docs.getdbt.com/docs/build/jinja-macros#macros str
    date_diff(
        '{{ datepart }}', 
        {{ second_date }},
        {{ first_date }}
        )

{%- endmacro %}


{% macro starrocks__dateadd(datepart, interval, from_date_or_timestamp) %}

    -- select date_add('2010-11-30 23:59:59', INTERVAL 2 DAY);
    date_add(
        {{ from_date_or_timestamp }}
        ,interval {{ interval }} {{ datepart }}
        )

{% endmacro %}



{% macro starrocks__date_spine(datepart, start_date, end_date) %}


{# call as follows:

date_spine(
    "day",
    "to_date('01/01/2016', 'mm/dd/yyyy')",
    "dbt.dateadd(week, 1, current_date)"
) #}


with rawdata as (

    {{dbt_utils.generate_series(
        dbt_utils.get_intervals_between(start_date, end_date, datepart)
    )}}

),

all_periods as (

    select (
        {{
            dbt.dateadd(
                datepart,
                "row_number() over () - 1",
                start_date
            )
        }}
    ) as date_{{datepart}}
    from rawdata

),

filtered as (

    select *
    from all_periods
    where date_{{datepart}} <= {{ end_date }}

)

select * from filtered

{% endmacro %}


    