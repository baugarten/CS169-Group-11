# app/mailer/notifier.rb
class Notifier < ActionMailer::Base
 
  def support_notification(sender)
    @sender = sender
    mail(:to => "[prevent_spam_raju]raju@oneprosper.org" ,
         :from => sender.email,
         :subject => "New #{sender.support_type} from OneProsper")
 end
end
