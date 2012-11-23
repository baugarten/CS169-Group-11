module CampaignHelper
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
      if video== 'recorded' and videos==nil or 
        video== 'link' and video_link.blank?
        error="No video submited"
        return false,error
      else
        return true,""
      end
    end

    def template_format_pass(a,b)

      if (a==nil && b==nil) || ( a=="" && b=="") ||( a==nil && b=="") || (a=="" && b==nil)
        return false,"Please Enter the Subject and Content"

      elsif a==nil || a=="" || a.blank?
        return false,"Please Enter the Template Subject"

      elsif b==nil || b=="" || b.blank?
        return false,"Please Enter the Template Content"
      else
        return true,""
      end
   end

   def create_campaign(campaign_id,project,valid_email,template_subject,template_content,video_type,video_link)
      if campaign_id == -1
        campaign = current_user.campaign.create
        campaign.project=Project.find(project)
      else
        campaign = Campaign.find_by_id(campaign_id)
      end
      campaign.campaign_friend.clear
      emails=valid_email
      
      emails.each do |temail,tname|
        friend = campaign.campaign_friend.new
      
        friend.name = tname
        friend.email = temail
        friend.save
      end

      campaign.email_subject = template_subject
      campaign.template = template_content
      
      if video_type == 0
        campaign.video = Video.create(video_link)
      elsif video_type == 1
        campaign.video = Video.create(:video_id => video_link)
      end

      campaign.video_link = campaign.video.link

      
      campaign.campaign_friend.each do |friend|
        friend.email_subject = campaign.email_subject
        friend.email_template = campaign.template
        friend.confirm_link= request.protocol+request.host_with_port+"/"+"campaigns/#{campaign.id}/confirm_watched?friend=#{friend.id}"
        friend.save
      end
      campaign.save
      return campaign
   end

end

class CampaignsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:confirm_watched]
  before_filter :check_owner, :only=>[:manager]
  include CampaignHelper

  def check_owner
    id = params[:id]
    campaign = Campaign.find_by_id(id)
    if campaign==nil
      flash[:error] = "Campaigns with id:#{params[:id]} doesnt exist!!"
      redirect_to dashboard_path
       
    elsif not campaign.user == current_user
      flash[:error] = "You may only view your campaigns"
      redirect_to dashboard_path
    end
  end

  def destroy
    @campaign = Campaign.find_by_id(params[:id])
    if @campaign != nil
      @campaign.destroy
      flash[:notice] = "Campaign was Deleted Successfully"
      redirect_to dashboard_path
    end
  end

  def edit
    @campaign = Campaign.find_by_id(params[:id])
  end

  def update
    @campaign = Campaign.find_by_id(params[:id])
    
    valid_email={}
    fail_list=""
    fail_list,valid_email,email_error=check_email_format(params[:campaign][:email_list])

    if not fail_list.empty?
      flash[:error]=email_error
      redirect_to edit_campaign_path(@campaign)
      return
    end

    video_format_passed,error=video_format_pass(params[:video],params[:campaign][:video_link],params[:videos])
    if not video_format_passed
      flash[:error]=error
      redirect_to edit_campaign_path(@campaign)
      return
    end

    template_format_passed,error=template_format_pass(params[:campaign][:email_subject],params[:campaign][:template])
    #render :text=>params[:template_subject].inspect
    if not template_format_passed
      flash[:error]=error
      redirect_to edit_campaign_path(@campaign)
      return
    end
    
    campaign=create_campaign(@campaign.id,-1,valid_email,params[:campaign][:email_subject],params[:campaign][:template],params[:video_type],params[:video_link])


    flash[:notice] = "Campaign was successfully updated"	
    redirect_to edit_campaign_path(@campaign)
  end
  
  def farmers
    @existed_projects=Campaign.all(:conditions=>["user_id=?",current_user.id])
    result=[]
    @existed_projects .each do|campaign|
      if campaign != nil && campaign.project!=nil
        result.push(campaign.project.id)
      end
    end
    if result.empty?
      result.push(-1)
    end

    @projects=Project.find(:all, :conditions => ["id NOT IN (?)", result])
  end
  
  def select_farmer
    session[:project]=params[:project]
    redirect_to friends_campaign_path()
  end
  
  def friends
    check_session_farmer()
  end
  
  def submit_friends
    
    session[:email_list]=params[:campaign][:email_list]
    email_friends_count=0
    valid_email={}
    fail_list=""

    fail_list,valid_email,error=check_email_format(params[:campaign][:email_list])
    
    session[:valid_email]=valid_email unless valid_email.size ==0
    
    if fail_list.size >0
      session[:valid_email]=nil 
      flash[:error] =error
      redirect_to friends_campaign_path()
    else
      redirect_to video_campaign_path
    end
  end
  
  def video
    check_session_friends
  end
  
  def submit_video
    
    video_format_passed,error=video_format_pass(params[:video],params[:campaign][:video_link],params[:videos])
    if not video_format_passed
      flash[:error]=error
      redirect_to video_campaign_path()
      return
    end

    if params[:video] == 'recorded'
      session[:video_link]=params[:videos]["0"]
      session[:video_type]=0
    else
      session[:video_link]=params[:campaign][:video_link]
      session[:video_type]=1
    end
  
    redirect_to template_campaign_path()
  end
  
  def template
    
  end
  
  def submit_template
    session[:template_content]=params[:campaign][:template]
    session[:template_subject]=params[:campaign][:email_subject]
    
    format_passed,error=template_format_pass(session[:template_subject],session[:template_content])
   
    if not format_passed
      flash[:error]=error
      redirect_to template_campaign_path
    
    elsif session[:valid_email]==nil || session[:project] ==nil || session[:video_type]==nil || session[:video_link]==nil
      flash[:error]="Incomplete information to create a campaign"
      redirect_to campaign_farmers_path
      return
    
    else
      campaign=create_campaign(-1,session[:project],session[:valid_email],session[:template_subject],session[:template_content],session[:video_type],session[:video_link])

      redirect_to manager_campaign_path(campaign)
    end
  end
  
  def manager
    @campaign = Campaign.find_by_id(params[:id])
    @friends = @campaign.campaign_friend
    reset_campaign_session
  end

  def track
     @campaign = Campaign.find_by_id(params[:id])   
     @friend=@campaign.campaign_friend.find(params[:friend])
     @friend.sent_count=@friend.sent_count+1
     @friend.save
  end

  def confirm_watched
     @campaign = Campaign.find_by_id(params[:id])
     @friend=@campaign.campaign_friend.find(params[:friend])
     if @friend.sent_count>0
        @friend.opened= @friend.opened+1
     else
        @friend.opened=0 
     end
     @friend.save
  end
end
