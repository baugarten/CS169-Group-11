class UpdatesController < ApplicationController
  before_filter :authenticate_admin!, :except =>  [ :index, :show ]

  def index
    sort = params[:sort] 
    case sort
    when 'title'
      ordering, @title_header = 'title', 'hilite'
    when 'created_date'
      ordering, @date_header = 'created_at', 'hilite'
    end
    
    @updates = Update.order(ordering).page(params[:page]).per(10)
  end

  def new
  end
  
  def show
    @update = Update.find(params[:id])
  end

  def create
    @update = Update.create!(params[:update])
    flash[:notice] = "Update was created successfully"
    redirect_to updates_path
  end

  def edit
    @update = Update.find params[:id]
  end

  def update
    @update = Update.find params[:id]
    @update.update_attributes!(params[:update])
    flash[:notice] = "Update was successfully edited"
    redirect_to update_path(@update)
  end

  def destroy
    @update = Update.find(params[:id])
    @update.destroy
    flash[:notice] = "Update '#{@update.title}' deleted."
    redirect_to updates_path
  end
end
