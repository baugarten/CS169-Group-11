class PhotoController < ApplicationController
  def display
	  @image_data = Photo.find(params[:id])
	  @image = @image_data.binary_data
	  send_data @image, :type     => @image_data.content_type, 
						:filename => @image_data.filename, 
						:disposition => 'inline'
  end
  def default
    return "before.jpeg"
  end
end
