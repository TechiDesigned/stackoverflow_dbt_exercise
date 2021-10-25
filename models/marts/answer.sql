-- This model answers the question of which unanswered questions where popular and trending during the month of September.
-- Posts are sorted by vote_count, comment_count, and then all_time_views. all_time_views are weighted the least since views
-- are not tracked historically and views do not represent engagement.

{{
    config(
        materialized='view'
    )
}}

SELECT 
post_id,
questions.title,
questions.tags,
sum(hist.vote_count) as vote_count,
sum(hist.comment_count) as comment_count,
questions.view_count as all_time_view_count
FROM {{ ref('fact_so_questions_hist') }} hist
--inner join is used to filter comments and votes from deleted posts
inner join {{ ref('stg_so__posts_questions') }} questions
on hist.post_id = questions.id
-- filter for the month of September
where full_date between '2021-08-01' and '2021-08-31'
--filter out answered questions
and questions.answer_count = 0
group by 1, 2, 3, 6 
order by 4 desc, 5 desc, 6 desc
LIMIT 100