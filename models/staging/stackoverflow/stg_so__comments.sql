select
id,	
text,	
cast(creation_date as date) as creation_date,
post_id,
user_id,
user_display_name,
score
from {{ source('stackoverflow','comments') }}