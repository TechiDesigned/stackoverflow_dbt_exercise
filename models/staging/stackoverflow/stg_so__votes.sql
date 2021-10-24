select
id,	
cast(creation_date as date) as creation_date,
post_id,
vote_type_id
from {{ source('stackoverflow','votes') }}	