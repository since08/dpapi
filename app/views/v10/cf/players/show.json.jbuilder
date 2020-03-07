# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.partial! 'short_info', cf_player: @player
  json.player_images do
    json.array! @player.player.player_images do |item|
      json.image item.image
    end
  end
  # 有多少人订购
  json.ordered do
    json.number @player.order_fans[:number]
    json.users do
      json.array! @player.order_fans[:users] do |item|
        json.user_id item.user_uuid
        json.nick_name item.nick_name.to_s
        json.avatar item.avatar_path.to_s
      end
    end
  end
  # 简介
  json.description @player.player.description
  json.race_rank do
    # 战绩
    json.array! @player.player.crowdfunding_ranks.includes(:race) do |rank|
      race = rank.race
      json.partial! 'cf_ranks', rank: rank, race: race
      next if race.nil?
    end
  end
end
