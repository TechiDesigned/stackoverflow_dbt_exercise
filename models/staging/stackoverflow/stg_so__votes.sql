select
votes.id,	
cast(votes.creation_date as date) as creation_date,
votes.post_id,
votes.vote_type_id
from {{ source('stackoverflow','votes') }} votes
