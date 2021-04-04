class ApplicationController < ActionController::API
  
  protected
  
  def verify_request_header
    unless  request.headers['content-type'] == 'application/json' ||
            request.headers['accept'] == 'application/json'
      render  json: { status: 406, message: 'Unsupported header' },
              status: 406
    end
  end

  def render_http_status(http_status)
    @status = http_status
    render status: @status
  end
end
