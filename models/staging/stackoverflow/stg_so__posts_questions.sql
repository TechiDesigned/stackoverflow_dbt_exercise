select
id,	
title,
body,	
accepted_answer_id,
case when answer_count is null then 0 
else answer_count 
end as answer_count,
comment_count,	
community_owned_date,
cast(creation_date as date) as creation_date,
favorite_count,
last_activity_date,	
last_edit_date,
last_editor_display_name,
last_editor_user_id,
owner_display_name,
owner_user_id,
parent_id,
post_type_id,	
score,
tags,	
view_count
from {{ source('stackoverflow','posts_questions') }}
where answer_count = 0 or answer_count is null