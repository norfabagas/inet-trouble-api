class Api::V1::Private::AdminController < ApplicationController
  before_action :authenticate
  before_action :check_is_admin

  def get_troubles
    available_types = ['all', 'read', 'unread']
  
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @size = params[:size].to_i.zero? ? 10 : params[:size].to_i
    @type = (available_types.include? params[:type]) ? params[:type] : 'all'
    @success = true
    @message = 'Internet Troubles data'

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
end
