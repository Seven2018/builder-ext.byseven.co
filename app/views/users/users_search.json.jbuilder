json.users do
  json.array! @users do |user|
    json.name user.fullname
    json.url user_path(user)
    json.id user.id
  end
end
