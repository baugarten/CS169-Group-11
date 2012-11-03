class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  def index
  end

  def frontpage
    @updates = Update.find(:all, :order => "created_at DESC", :limit => 5)
  end
end
