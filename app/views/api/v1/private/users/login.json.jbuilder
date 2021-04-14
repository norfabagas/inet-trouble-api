json.success @success
json.message @message
if @status == 200
  json.regular_user @regular_user
  json.token @token
end