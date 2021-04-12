class Api::V1::Private::AdminController < ApplicationController
  before_action :authenticate
  before_action :is_admin?

  def get_troubles
    
  end
end
