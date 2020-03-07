json.id          list.id
json.type_id     list.video_type_id
json.type        list.video_type.try(:name).to_s
json.tag_id      list.race_tag_id
json.tag         list.race_tag.try(:name).to_s
json.name        list.name.to_s
json.title_desc  list.title_desc.to_s
json.video_link  list.video_link.to_s
json.cover_link  list.cover_link.to_s
json.video_duration list.video_duration.to_s
json.top         list.top
json.description list.description.to_s
json.total_views list.total_views
json.total_likes list.total_likes
json.total_comments list.comments.count
json.current_user_like list.topic_likes.find_by(user: @current_user).present?