class DashboardController < ApplicationController
  before_filter :authenticate_user!

	def show
		@user = current_user
	end

	def upload_picture
		unless params[:profile_picture_file]
			flash[:error] = "No picture uploaded"
			redirect_to dashboard_path
			return
		end
		image_data = params[:profile_picture_file]

		user_photo = Photo.new
		user_photo.image_file = image_data
		current_user.photo = user_photo
		current_user.save!
		
		flash[:notice] = "Profile picture uploaded successfully"
		redirect_to dashboard_path
	end
end
