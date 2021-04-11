json.success @success
json.message @message
if @status == 200
  json.internet_trouble do
    json.trouble @internet_trouble.trouble
    json.status @internet_trouble.status
    json.category @internet_trouble.category
    json.is_predicted @internet_trouble.is_predicted
  end
end