class Api::V1::Public::InternetTroublesController < ApplicationController

  def show
    email = params[:email]
    trouble_id = params[:trouble_id]

    if email && trouble_id
      @internet_trouble = InternetTrouble.find(trouble_id) rescue nil

      if @internet_trouble && @internet_trouble.user.email == email
        @success = true
        @message = 'Internet Trouble Found'
        render_http_status 200
      else
        @success = false
        @message = 'Not Found'
        render_http_status 404
      end

    else
      @success = false
      @message = 'Not Found'
      render_http_status 404
    end


  end
end
