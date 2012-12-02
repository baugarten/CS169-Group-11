class Photo < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true
  attr_accessible :binary_data, :input_data
  attr_reader :input_data
  attr_accessor :input_data

  attr_accessible :url

  before_validation :init

  def init
    if self.input_data

    end
  end
  def image_file=(input_data)
    self.filename = input_data.original_filename
    self.content_type = input_data.content_type.chomp
    self.binary_data = input_data.read
  end
end
