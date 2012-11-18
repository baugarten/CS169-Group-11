class Donation < ActiveRecord::Base
  attr_accessible :email, :amount, :project_id, :user_id, :stripe_token, :readable_amount
  
  belongs_to :project
  belongs_to :user
  
  def readable_amount
    donation_amount = self.amount
    dollars = donation_amount / 100
    cents = donation_amount % 100
    if (cents < 10)
      cents = "0" + String(cents)
    end
    return "$#{dollars}.#{cents}"
  end
  
  def readable_amount=(in_amount)
    parse = /\$?(?<dollars>\d+)(.(?<cents>\d*))?/.match(in_amount)
    
    dollars = 0
    cents = 0
    
    if not parse
      self.amount = 0
      return
    end
    
    if (parse[:dollars])
      dollars = Integer(parse[:dollars])
    end
    
    if (parse[:cents])
      cents = Integer(parse[:cents])
    end
    
    self.amount = (dollars * 100) + cents
  end
end
