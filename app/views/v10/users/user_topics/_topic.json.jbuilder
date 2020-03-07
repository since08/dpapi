json.user do
  json.partial! 'v10/users/user_info', user: topic.user
end
json.id               topic.id
json.title            topic.title
json.cover_link       topic.cover_link
json.body             topic.body
json.body_type        topic.body_type
json.recommended      topic.recommended
json.abnormal         topic.abnormal
json.location do
  json.lat topic.lat
  json.lng topic.lng
  json.address_title topic.address_title.to_s
  json.address topic.address.to_s
end
json.deleted          topic.deleted
json.deleted_at       topic.deleted_at.to_i
json.deleted_reason   topic.deleted_reason
json.created_at       topic.created_at.to_i

if topic&.topic_images.present? && topic.short?
  json.images do
    json.array! topic.topic_images do |image|
      json.image_url image&.image_path.to_s
    end
  end
end
json.partial! 'v10/users/user_topics/counter', topic: topic
json.is_like @user_like_ids.present? && @user_like_ids.include?(topic.id)
