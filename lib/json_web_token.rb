module JsonWebToken
  def encode(payload)
    JWT.encode(payload, ENV['API_SECRET'])
  end

  def decode(token)
    begin
      decoded_token = JWT.decode(token, ENV['API_SECRET'], true, algorithm: 'HS256')
      decoded_token[0]['user_id']
    rescue JWT::DecodeError
      nil
    end
  end

  def token
    authorization = request.headers['Authorization']
    authorization.split(' ')[1] unless authorization.nil?
  end

  def payload(user_id)
    { user_id: user_id }
  end
end