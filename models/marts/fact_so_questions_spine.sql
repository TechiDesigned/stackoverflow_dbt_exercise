-- This model sums the counts of votes and comments per day per post.
-- A record is only created if it's the day the post was created or if 
-- the post recieves 1 or more comments or votes on a given day

{{
    config(
        materialized='table'
    )
}}

with all_days as (
    Select date_id, full_date
    from{{ ref('dim_date') }}
),
max_date as (
    select max(creation_date)
    from {{ ref('stg_so__posts_questions') }}
),
questions as (
    select creation_date, id
    from {{ ref('stg_so__posts_questions') }}
),
comments as (
    select creation_date, post_id, count(*) as comment_count
    from {{ ref('stg_so__comments') }}
    group by 1,2
),
votes as (
    select creation_date, post_id, count(*) as vote_count
    from {{ ref('stg_so__votes') }}
    group by 1,2
),
fact_so_questions_spine as (
    select
    {{ dbt_utils.surrogate_key(
    'full_date', 'post_id'
) }} as questions_key,
    date_id,
    full_date,
    post_id,
    sum(comment_count) as comment_count,
    sum(vote_count) as vote_count
    from (
    select    
    all_days.date_id,
    all_days.full_date,
    questions.id as post_id,
    0 as comment_count,
    0 as vote_count
    from all_days
    inner join questions on all_days.full_date = questions.creation_date
    union all
    select 
    all_days.date_id,
    all_days.full_date,
    comments.post_id,
    comments.comment_count,
    0 as vote_count
    from all_days
    inner join comments on all_days.full_date = comments.creation_date
    union all
    select 
    all_days.date_id,
    all_days.full_date,
    votes.post_id,
    0 as comment_count,
    votes.vote_count
    from all_days
    inner join votes on all_days.full_date = votes.creation_date
    )
    group by 1, 2, 3, 4
)

select * 
from fact_so_questions_spine
order by full_date