json.success @success
json.message @message
if @success
  json.internet_trouble do
    json.id @internet_trouble.id
    json.trouble @internet_trouble.trouble
    json.status @internet_trouble.status
    json.category @internet_trouble.category
    json.is_predicted @internet_trouble.is_predicted
  end
end