module CampaignsHelper
    require 'email_veracity'
    def fail_check_session_farmer()      
      if session[:project] ==nil
         flash[:error]="Please Select a Farmer"
         return true
      end
      session[:template_content]=nil
      session[:template_subject]=nil
      session[:valid_email]=nil
      session[:video_link]=nil
      session[:video_type]=nil
      return false
    end

    def reset_campaign_session
      session[:template_content]=nil
      session[:template_subject]=nil
      session[:project]=nil
      session[:valid_email]=nil
      session[:video_link]=nil
      session[:video_type]=nil
      session[:email_list]=nil
    end

    def valid_email?(email)
      first, last, email = parse_email(email)
      email_address = EmailVeracity::Address::new(email.delete("<").delete(">"))
      if email_address.valid?
        return true
      else
        return false
      end
    end

    def parse_email(full_email)
      fname, lname = "", ""
      if index = full_email.index(/\<.+\>/)
        email = full_email.match(/\<.*\>/)[0].gsub(/[\<\>]/, "").strip
        name  = full_email[0..index-1].split(" ")
        fname = name.first
        lname = name[1..name.size] * " "
      else
        email = full_email.strip
        #your choice, what the string could be... only mail, only name?
      end
      return fname, lname, email
    end

    def valid_campaign_video?(videohash)
      if videohash[:video] == "recorded"
        ret = !videohash[:videos].nil?
      else
        ret = !videohash[:campaign][:video_link].nil?
      end
    end

    # Parses a valid campaign video from videohash
    def parse_campaign_video(videohash)
      if videohash[:video] == 'recorded'
        return videohash[:videos]["0"]
      else
        return videohash[:campaign][:video_link]
      end
    end

    def template_format_pass(subject,content)

      if (subject==nil && content==nil) || ( subject=="" && content=="") ||( subject==nil && content=="") || (subject=="" && content==nil)
        return false,"Please Enter the Subject and Content"

      elsif subject==nil || subject=="" || subject.blank?
        return false,"Please Enter the Template Subject"

      elsif content==nil || content=="" || content.blank?
        return false,"Please Enter the Template Content"
      else
        return true,""
      end
   end

   def create_campaign(campaign_id, project_id, campaign_friends,
                       template_subject, template_content)
      if campaign_id == nil
        campaign = current_user.campaign.create
        campaign.project=Project.find(project_id)
      else
        campaign = Campaign.find_by_id(campaign_id)
      end
      campaign.campaign_friend.clear
      campaign.email_subject = template_subject
      campaign.template = template_content

      friends = []

      campaign_friends.each do |friend|
        friend.campaign = campaign
        friend.email_subject = campaign.email_subject
        friend.email_template = campaign.template
        friend.confirm_link= request.protocol+request.host_with_port+"/"+"campaigns/#{campaign.id}/confirm_watched?friend=#{friend.id}"
        friends << friend
      end
      campaign.campaign_friend = campaign_friends
      campaign.save

      return campaign
   end

   def html_symbol_process(email_part)
     email_part=email_part.gsub(' ','%20')
     email_part=email_part.gsub('!','%21')
     email_part=email_part.gsub('"','%22')
     email_part=email_part.gsub('#','%23')
     email_part=email_part.gsub('$','%24')
     email_part=email_part.gsub('%','%25')
     email_part=email_part.gsub('&','%26')
     email_part=email_part.gsub('\'','%27')
     email_part=email_part.gsub('(','%28')
     email_part=email_part.gsub(')','%29')
     email_part=email_part.gsub('*','%2A')
     email_part=email_part.gsub('+','%2B')
     email_part=email_part.gsub(',','%2C')
     email_part=email_part.gsub('-','%2D')
     email_part=email_part.gsub('.','%2E')
     email_part=email_part.gsub('/','%2F')
     email_part=email_part.gsub(':','%3A')
     email_part=email_part.gsub(';','%3B')
     email_part=email_part.gsub('<','%3C')
     email_part=email_part.gsub('=','%3D')
     email_part=email_part.gsub('>','%3E')
     email_part=email_part.gsub('?','%3F')
     email_part=email_part.gsub('@','%40')
     email_part=email_part.gsub('{','%7B')
     email_part=email_part.gsub('|','%7C')
     email_part=email_part.gsub('}','%7D')
     email_part=email_part.gsub('~','%7E')
     return email_part
   end

end
