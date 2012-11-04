class DashboardController < ApplicationController
  before_filter :authenticate_user!

	def show
		@user = current_user
	end

	def edit
		@user = current_user
	end
	
  def update
    notice = ""
    # Change user profile text data
    new_user_data = params[:user];
    if (new_user_data[:password].empty? && new_user_data[:password_confirmation].empty?)
      new_user_data.delete(:password)
      new_user_data.delete(:password_confirmation)
    end
    current_user.update_attributes(new_user_data)
    if (current_user.valid?)
      notice += "Profile updated successfully"
      current_user.save!
    else
      error = "Error:"
      current_user.errors.each do |key, value|
        error << "<br/>#{key}: #{value}"
      end
      flash[:error] = error
      redirect_to dashboard_edit_path()
      return
    end

    # Upload new image
		if params[:user_image_file]
      image_data = params[:user_image_file]

      user_photo = Photo.new
      user_photo.image_file = image_data
      current_user.photo = user_photo
      current_user.save!
      
      notice += "<br/>Picture uploaded successfully"
		end
    
    flash[:notice] = notice
    
		redirect_to dashboard_path
  end
end
