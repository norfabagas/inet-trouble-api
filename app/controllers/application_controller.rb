class ApplicationController < ActionController::API

  include JsonWebToken
  
  protected
  
  def verify_request_header
    unless  request.headers['content-type'] == 'application/json' ||
            request.headers['accept'] == 'application/json'
      render  json: { status: 406, message: 'Unsupported header' },
              status: 406
    end
  end

  def authenticated?
    !(token && decode(token)).nil? ? !User.find(decode(token)).nil? : false
  end

  def authenticate
    if authenticated?
      @user = User.find(decode(token))
    else
      render  json:   { success: false, message: 'Unauthorized' },
              status: 403
    end
  end

  def render_http_status(http_status)
    @status = http_status
    render status: @status
  end
end
