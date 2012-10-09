class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  def index
  end

  def after_sign_up_path_for(resource)
    '/'
  end
end
