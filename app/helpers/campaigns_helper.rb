module CampaignsHelper
    def check_session_farmer()      
      if session[:project] ==nil
         flash[:error]="Please Select a Farmer"
         redirect_to campaign_farmers_path
         return
      end
      session[:template_content]=nil
      session[:template_subject]=nil
      session[:valid_email]=nil
      session[:video_link]=nil
      session[:video_type]=nil
    end

    def check_session_friends()
      if session[:valid_email] ==nil
        flash[:error]="Please Enter Some Valid Name and Email"
        redirect_to friends_campaign_path
        return
      end
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

    def check_email_format(email_list)
      valid_email={}
      fail_list=""
      email_list.split(',').each do |entry|
        name=""
        email=""
      
        entry.scan(/[\s]?([\w\s]+)<([\s+\w+\.\@]+)>+/).each do |y|
          name=y[0]
          email=y[1]
        end
      
        array=name.split(' ')
        if array.size !=2
          fail_list.empty? ? fail_list=entry : fail_list += ", "+entry
        else
          name=array[0]+" "+array[1]

          email =email.match(/^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i) 

          if email =="" || email ==nil || email.blank?
            fail_list.empty? ? fail_list=entry : fail_list += ","+entry          
          else
            valid_email["#{email}"]="#{name}" 
          end  
        end
      end
      
      return fail_list,valid_email,"Unable to understand these emails: #{fail_list}"
    end

    def video_format_pass(video,video_link,videos)
      if (video== 'recorded' && videos==nil) || (video== 'link' && video_link.blank?)
        error="No video submited"
        return false,error
      else
        return true,""
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

   def create_campaign(campaign_id,project_id,valid_email,template_subject,template_content,video_type,video_link)
      if campaign_id == nil
        campaign = current_user.campaign.create
        campaign.project=Project.find(project_id)
      else
        campaign = Campaign.find_by_id(campaign_id)
      end
      campaign.campaign_friend.clear
      emails=valid_email
 
      friends = []
      emails.each do |temail,tname|
        new_friend=CampaignFriend.new()
      
        new_friend.name = tname
        new_friend.email = temail
        new_friend.save
        friends.push(new_friend)
      end
      campaign.campaign_friend= friends


      campaign.email_subject = template_subject
      campaign.template = template_content
      
      if video_type == "webcam"
        campaign.video = Video.create(video_link)
      elsif video_type == "link"
        campaign.video = Video.create(:video_id => video_link)
      end

      campaign.campaign_friend.each do |friend|
        friend.email_subject = campaign.email_subject
        friend.email_template = campaign.template
        friend.confirm_link= request.protocol+request.host_with_port+"/"+"campaigns/#{campaign.id}/confirm_watched?friend=#{friend.id}"
        friend.save
      end
      campaign.save
      return campaign
   end

   def html_symbol_process(email_part)
     email_part=email_part.gsub(' ','%20')
     email_part=email_part.gsub(':','%3A')
     email_part=email_part.gsub('/','%2F')
     email_part=email_part.gsub('?','%3F')
     email_part=email_part.gsub('=','%3D')
     return email_part
   end

end
