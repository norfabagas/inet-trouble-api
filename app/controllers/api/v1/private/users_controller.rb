class Api::V1::Private::UsersController < ApplicationController
  
  before_action :verify_request_header
  
  def create
    @user = User.create(user_params)
    if @user.valid?
      @message = "Created"
      render_http_status 201
    else
      @message = @user.errors.messages
      render_http_status 400
    end
  end

  def login
    email = params[:email]
    password = params[:password]
    @user = User.find_by_email(email)
    
    @success = true

    if @user&.authenticate_password(password)
      @token = encode(payload(@user.id))
      @message = "Authenticated"
      @regular_user = !is_admin?
      render_http_status 200
    else
      @success = false
      @message = "Authentication failed"
      render_http_status 400
    end
  end

  private

  def user_params
    params.permit(  :name, 
                    :email, 
                    :password )
  end
end
