class UsersController < ApplicationController

  before_filter :authenticate_admin!
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def promote
    @user = User.find(params[:id])
    @admin = Admin.create({ 
      :email => @user.email,
      :encrypted_password => @user.encrypted_password
    })
    redirect_to users_url, notice: "User was promoted successfully"
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url
  end
end
