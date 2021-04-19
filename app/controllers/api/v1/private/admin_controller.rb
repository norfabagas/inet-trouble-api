class Api::V1::Private::AdminController < ApplicationController
  before_action :authenticate
  before_action :check_is_admin

  def get_troubles
    available_types = ['all', 'read', 'unread']
  
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @size = params[:size].to_i.zero? ? 5 : params[:size].to_i
    @type = (available_types.include? params[:type]) ? params[:type] : 'all'
    @success = true
    @message = 'Internet Troubles data'
    @total_size = InternetTrouble.count
    @total_page = (@total_size / @size).ceil + (@total_size % @size > 0 ? 1 : 0)
    if @total_size <= @size
      @total_page = 1
    end

    if @type == 'read'
      @internet_troubles = InternetTrouble.read_by_admin
                                            .offset((@page - 1) * @size)
                                            .limit(@size)
                                            .order(id: :desc)
    elsif @type == 'unread'
      @internet_troubles = InternetTrouble.unread_by_admin
                                            .offset((@page - 1) * @size)
                                            .limit(@size)
                                            .order(id: :desc)
    else
      @internet_troubles = InternetTrouble.offset((@page - 1) * @size)
                                            .limit(@size)
                                            .order(id: :desc)
    end

  end
end
