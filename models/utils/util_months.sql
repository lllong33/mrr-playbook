{{ dbt_utils.date_spine(
    datepart="month",
    start_date="'2018-01-01'",
    end_date="date_trunc('month', current_date)"
   )
}}

-- date dim, generate column month = [start_month, +1, +1, ..., end_month]
-- rawdata [1,2,3,4,....,diff]
