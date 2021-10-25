
{{
    config(
        materialized='incremental', incremental_strategy='insert_overwrite'
    )
}}

with fact_so_questions_spine as (
    select *
        from {{ ref('fact_so_questions_spine') }}
    {% if is_incremental () %}
    -- this filter will only be applied on an incremental run
    where full_date > (Select max(fulll_date) from {{ this }})
    {% endif %}
)
select *
from fact_so_questions_spine