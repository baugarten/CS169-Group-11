class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  def index
  end

  def frontpage
    @updates = Update.find(:all, :order => "created_at DESC", :limit => 5)
    @page = 1
    if params[:page]
      @page = params[:page].to_i
    end
    @projects = Project.top_projects(@page)
    @count = Project.all.count
  end
end
