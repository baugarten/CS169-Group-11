class Project < ActiveRecord::Base
  has_many :videos, :as => :recordable
  has_many :photos, :as => :imageable
  has_many :donations


  attr_accessible :farmer, :description, :target, :end_date, :ending, :priority, :current, :completed, :videos_attributes, :campaign_id, :photos_attributes

  accepts_nested_attributes_for :videos, :reject_if => lambda { |video| video[:video_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :photos, :reject_if => lambda { |photo| photo[:input_data].blank? }, :allow_destroy => true

  after_initialize :init

  validates :farmer, :presence => true, :uniqueness => true
  validates :description, :presence => true
  validates :target, :presence => true, :numericality => true
  validate :end_date_or_no_ending
  validates :current, :numericality => true

  def update_current_donated
    total = 0
    self.donations.each do |donation|
      total += donation.amount/100
    end
    
    self.current = total
    self.save!
  end
  
  def end_date_or_no_ending
    # There must be an end date or it must go on indefinitely
    if end_date.nil? and not ending
      errors.add(:end_date, "You must choose an end date or select Not Ending")
    end
  end

  def init
    self.current ||= 0
    self.priority ||= 1
    self.target ||= 0
    self.completed = (self.target <= self.current unless self.completed or self.target == 0)
  end

  def self.top_projects(page)
    Project.order("priority DESC, created_at DESC").page(page).limit(12)
  end
end
