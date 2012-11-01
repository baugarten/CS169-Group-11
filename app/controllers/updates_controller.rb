class UpdatesController < ApplicationController
  def index
    @updates = Update.page(params[:page]).per(1)
  end

  def new
  end
  
  def show
    @update = Update.find(params[:id])
  end

  def create
    @update = Update.create!(params[:update])
    flash[:notice] = "#{@update.title} was created successfully"
    redirect_to updates_path
  end

  def edit
    @update = Update.find params[:id]
  end

  def update
    @update = Update.find params[:id]
    @update.update_attributes!(params[:update])
    flash[:notice] = "#{@update.title} was successfully updated"
    redirect_to update_path(@update)
  end

  def destroy
    @update = Update.find(params[:id])
    @update.destroy
    flash[:notice] = "Update '#{@update.title}' deleted."
    redirect_to updates_path
  end
end
