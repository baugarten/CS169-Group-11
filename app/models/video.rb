class Video < ActiveRecord::Base
  belongs_to :recordable, :polymorphic => true

  def link
    return "http://youtube.com/watch?v=#{self.video_id}"
  end
  # attr_accessible :title, :body
end
