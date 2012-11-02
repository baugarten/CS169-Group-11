class UpdatesController < ApplicationController
  before_filter :authenticate_admin!, :except =>  [ :index, :show ]

  def index
    sort = params[:sort] 
    case sort
    when 'title'
      ordering, @title_header = :title, 'hilite'
    when 'created_date'
      ordering, @date_header = :created_at, 'hilite'
    end
    
    @updates = Update.order(ordering).page(params[:page]).per(10)
  end

  def new
    @update = Update.new(params[:update])
  end
  
  def show
    @update = Update.find(params[:id])
  end

  def create
    @update = Update.new(params[:update])
    if @update.save
      flash[:notice] = "Update was created successfully"
      redirect_to updates_path
    else
      render 'new'
    end
  end

  def edit
    @update = Update.find params[:id]
  end

  def update
    @update = Update.find params[:id]
    if @update.update_attributes(params[:update])
      flash[:notice] = "Update was edited successfully"
      redirect_to update_path(@update)
    else
      render 'edit'
    end
  end

  def destroy
    @update = Update.find(params[:id])
    @update.destroy
    flash[:notice] = "Update was deleted successfully"
    redirect_to updates_path
  end
end
