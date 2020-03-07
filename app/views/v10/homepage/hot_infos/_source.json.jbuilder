if source.class.name == 'Info'
  json.info do
    json.id          source.id
    json.title       source.title.to_s
    json.date        source.date
    json.image_thumb source.image_thumb.to_s
    json.description source.description.to_s
    json.source_type source.source_type.to_s
    json.source      source.source.to_s
    json.total_views source.total_views
    json.total_likes source.total_likes
    json.total_comments source.comments.count
    json.current_user_like source.topic_likes.find_by(user: @current_user).present?
  end
else
  json.video do
    json.id             source.id
    json.name           source.name.to_s
    json.title_desc     source.title_desc.to_s
    json.video_link     source.video_link.to_s
    json.cover_link     source.cover_link.to_s
    json.video_duration source.video_duration.to_s
    json.description    source.description.to_s
    json.group_id       source.video_group_id
    json.group_name     source.video_group.try(:name).to_s
    json.total_views    source.total_views
    json.total_likes    source.total_likes
    json.total_comments source.comments.count
    json.current_user_like source.topic_likes.find_by(user: @current_user).present?
  end
end