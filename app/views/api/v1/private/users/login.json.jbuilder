if @status == 200
  json.success true
  json.message @message
  json.token @token
elsif @status == 400
  json.success false
  json.message @message
end