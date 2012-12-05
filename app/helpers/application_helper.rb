module ApplicationHelper
  def default_photo_path
    return 'before.jpeg'
  end

  def photo_path(photo)
    if !photo.url.nil? and !photo.url.blank?
      return photo.url
    end
  end
end
