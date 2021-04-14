json.success @success
json.message @message
if @status == 200
  json.regular_user @regular_user
  json.name @user.name
  json.token @token
end