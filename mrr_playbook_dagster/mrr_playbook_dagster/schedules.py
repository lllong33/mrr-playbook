"""
To add a daily schedule that materializes your dbt assets, uncomment the following lines.
"""
from dagster_dbt import build_schedule_from_dbt_selection

from .assets import acme_dbt_assets

schedules = [
    build_schedule_from_dbt_selection(
        [acme_dbt_assets],
        job_name="materialize_dbt_models",
        cron_schedule="0 0 * * *", # 表示每天凌晨0点执行
        dbt_select="fqn:*",
    ),
]