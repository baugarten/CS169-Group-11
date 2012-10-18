class Project < ActiveRecord::Base
  attr_accessible :farmer, :description, :target, :end_date, :ending, :priority, :current, :completed
  after_initialize :init

  def init
    self.current ||= 0
    if not self.end_date
      self.ending = false
    end
    self.priority ||= 1
    self.target ||= 0
    self.completed = (self.target <= self.current unless self.completed or self.target == 0)
  end
end
