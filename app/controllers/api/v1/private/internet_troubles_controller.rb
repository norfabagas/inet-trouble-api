class Api::V1::Private::InternetTroublesController < ApplicationController  
  
  before_action :authenticate

  def index
    available_types = ['all', 'read', 'unread']
  
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @size = params[:size].to_i.zero? ? 5 : params[:size].to_i
    @total_size = @user.internet_troubles.count
    @total_page = (@total_size / @size).ceil + (@total_size % @size > 0 ? 1 : 0)
    if @total_size <= @size
      @total_page = 1
    end
    @type = (available_types.include? params[:type]) ? params[:type] : 'all'
    @success = true
    @message = 'Internet Troubles data'

    if @type == 'read'
      @internet_troubles = @user.internet_troubles
                                .read_by_admin
                                .offset((@page - 1) * @size)
                                .limit(@size)
                                .order(id: :desc)
    elsif @type == 'unread'
      @internet_troubles = @user.internet_troubles
                                .unread_by_admin
                                .offset((@page - 1) * @size)
                                .limit(@size)
                                .order(id: :desc)
    else
      @internet_troubles = @user.internet_troubles
                                .offset((@page - 1) * @size)
                                .limit(@size)
                                .order(id: :desc)
    end
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
