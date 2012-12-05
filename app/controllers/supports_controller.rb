class SupportsController < ApplicationController
  def new
    @support = Support.new(:id => 1)
  end
 
  def create
    @support = Support.new(params[:support])
    if @support.save
      redirect_to('/supports/new', :notice => "Request was successfully sent.")
    else
      flash[:alert] = "Please fill in all the fields."
      render 'new'
    end

  end

end
