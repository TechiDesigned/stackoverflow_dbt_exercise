select
id,	
name,	
cast(date as date) as date,	
user_id,		
tag_based
from {{ source('stackoverflow','badges') }}