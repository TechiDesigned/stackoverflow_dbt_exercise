select
votes.id,	
cast(votes.creation_date as date) as creation_date,
votes.post_id,
votes.vote_type_id
from {{ source('stackoverflow','votes') }} votes
left join {{ source('stackoverflow','posts_questions') }} questions on votes.post_id = questions.id 
where questions.answer_count = 0 or questions.answer_count is null