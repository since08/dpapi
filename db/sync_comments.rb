# 同步话题对应的评论数

%w(Info Video UserTopic).each do |m|
  m.constantize.all.each do |r|
    comments = r.comments
    r.counter.update!(comments: comments.inject(comments.count) { |result, element| result + element.reply_count })
  end
end