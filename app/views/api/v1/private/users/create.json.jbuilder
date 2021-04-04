if @status == 201
  json.success true
  json.message @message
  json.user do
    json.name @user.name
    json.email @user.email
    json.created @user.created_at
  end
elsif @status == 400
  json.success false
  json.message @message
end