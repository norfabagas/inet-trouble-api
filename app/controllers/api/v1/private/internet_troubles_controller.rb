class Api::V1::Private::InternetTroublesController < ApplicationController  
  
  before_action :authenticate
  
  def create
    params[:user_id] = @user.id
    @internet_trouble = InternetTrouble.create(internet_trouble_params)
    if @internet_trouble.valid?
      @success = true
      @message = 'Internet Trouble Created'
      render_http_status 201
    else
      @success = false
      @message = @internet_trouble.errors.messages
      render_http_status 400
    end
  end

  def edit
    params[:user_id] = @user.id
    id = params[:id]
    @internet_trouble = InternetTrouble.where(id: params[:id], user_id: params[:user_id]).first
    if @internet_trouble
      if @internet_trouble.update(internet_trouble_params)
        @success = true
        @message = 'Internet trouble updated'
        render_http_status 200
      else
        @success = false
        @message = @internet_trouble.errors.messages
        render_http_status 400
      end
    else
      @success = false
      @message = 'Not Found'
      render_http_status 404
    end

  end

  private

  def internet_trouble_params
    params.permit(  :user_id,
                    :trouble,
                    :category,
                    :status,
                    :is_predicted )
  end
end
