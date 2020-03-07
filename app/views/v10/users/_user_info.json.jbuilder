json.user_id user.user_uuid
json.nick_name user.nick_name.to_s
json.avatar user.avatar_path.to_s
json.signature user.signature.to_s
json.official user.role.eql?('official')