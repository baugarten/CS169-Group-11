class Donation < ActiveRecord::Base
  attr_accessible :email, :amount, :project, :project_id, :campaign_friend, :campaign_friend_id, :user_id, :stripe_token, :readable_amount
  
  belongs_to :project
  belongs_to :user
  belongs_to :campaign_friend
  
  def readable_amount
    return "" if self.amount == 0 or not self.amount
    
    donation_amount = self.amount
    dollars = donation_amount / 100
    cents = donation_amount % 100
    if (cents < 10)
      cents = "0" + String(cents)
    end
    return "$#{dollars}.#{cents}"
  end
  
  def readable_amount=(in_amount)
    parse = /^\$?(?<amount>[\d.-]+)$/.match(in_amount)
    
    self.amount = 0
    
    return if not parse
    
    # rounding is necessary because of FP precision issues
    # example: inputting $19.99 would have returned $19.98
    self.amount = ((parse[:amount].to_f + 0.0049) * 100).to_i
  end
end
