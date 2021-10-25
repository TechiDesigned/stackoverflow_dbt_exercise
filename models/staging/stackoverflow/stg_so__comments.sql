select
comments.id,	
comments.text,	
cast(comments.creation_date as date) as creation_date,
comments.post_id,
comments.user_id,
comments.user_display_name,
comments.score
from {{ source('stackoverflow','comments') }} comments
left join {{ source('stackoverflow','posts_questions') }} questions on comments.post_id = questions.id 
where questions.answer_count = 0 or questions.answer_count is null