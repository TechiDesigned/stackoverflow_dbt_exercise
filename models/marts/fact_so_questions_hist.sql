
-- This model incrementally stores the comment and vote history for posts

{{
    config(
        materialized='incremental'
    )
}}

with fact_so_questions_spine as (
    select *
        from {{ ref('fact_so_questions_spine') }}
    {% if is_incremental () %}
    -- this filter will only be applied on an incremental run
    where full_date > (Select max(full_date) from {{ this }})
    {% endif %}
)
select *
from fact_so_questions_spine