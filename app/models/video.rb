class Video < ActiveRecord::Base
  before_save :id_from_url

  belongs_to :recordable, :polymorphic => true

  attr_accessible :video_id

  def link
    return "http://youtube.com/watch?v=#{self.video_id}"
  end

  def id_from_url
    uri = URI.parse(self.video_id)
    if uri.query.nil? then return self.video_id end
    params = CGI.parse(uri.query)
    self.video_id = params['v'][0]
  rescue URI::BadURIError, URI::InvalidURIError
    
  end
end
