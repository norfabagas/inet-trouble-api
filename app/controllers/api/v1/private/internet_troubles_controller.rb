class Api::V1::Private::InternetTroublesController < ApplicationController  
  
  before_action :authenticate

  def index
    available_types = ['all', 'read', 'unread']
  
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @size = params[:size].to_i.zero? ? 10 : params[:size].to_i
    @type = (available_types.include? params[:type]) ? params[:type] : 'all'
    @success = true
    @message = 'Internet Troubles data'
    @total_size = InternetTrouble.count
    @total_page = (@total_size / @size).ceil

    if @type == 'read'
      @internet_troubles = InternetTrouble.read_by_admin
    elsif @type == 'unread'
      @internet_troubles = InternetTrouble.unread_by_admin
    else
      @internet_troubles = InternetTrouble.get_all
    end
    @internet_troubles.offset(@page)
                      .limit(@size)
                      .order('created_at desc')
  end

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

    if is_admin?
      @internet_trouble = InternetTrouble.find(params[:id]) rescue nil
    else
      @internet_trouble = InternetTrouble.where(id: params[:id], user_id: params[:user_id]).first
    end
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
