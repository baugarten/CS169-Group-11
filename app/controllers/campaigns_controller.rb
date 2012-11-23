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
      session[:email_list]=nil
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
    else
      flash[:notice] = "No campaign with id:#{params[:id]}"
      redirect_to dashboard_path
    end
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
    fail_list=""
    session[:email_list]=params[:campaign][:email_list]

    @email_list=params[:campaign][:email_list]
    email_friends_count=0
    valid_email={}
    
    @email_list.split(',').each do |entry|
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
        
        if email =="" || email ==nil
          fail_list.empty? ? fail_list=entry : fail_list += ","+entry
        end

        valid_email["#{email}"]="#{name}"   
      end
    end
    
    session[:valid_email]=valid_email unless valid_email.size ==0
  
    if fail_list.size >0
      session[:valid_email]=nil 
      flash[:error] ="Unable to understand these emails: #{fail_list}"
      redirect_to friends_campaign_path()
    else
      redirect_to video_campaign_path
    end
  end
  
  def video
    check_session_friends
  end
  
  def submit_video
    
    if params[:video] == 'recorded' and params[:videos].nil? or 
      params[:video] == 'link' and params[:campaign][:video_link].blank?
      flash[:error]="No video submited"
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
    #check_session_video
  end
  
  def submit_template
    session[:template_content]=params[:campaign][:template]
    session[:template_subject]=params[:campaign][:email_subject]
    
    a=session[:template_subject]
    b=session[:template_content]
    
    if session[:valid_email]==nil || session[:project] ==nil || session[:video_type]==nil || session[:video_link]==nil
      flash[:error]="Incomplete information to create a campaign"
      redirect_to campaign_farmers_path
      return
    end

    if (a==nil && b==nil) || ( a=="" && b=="") ||( a==nil && b=="") || (a=="" && b==nil)
      flash[:error]="Please Enter the Subject and Content"
      redirect_to template_campaign_path
      return

    elsif session[:template_subject] ==nil || session[:template_subject]==""
      flash[:error]="Please Enter the Template Subject"
      redirect_to template_campaign_path
      return

    elsif session[:template_content]==nil || session[:template_content]==""
      flash[:error]="Please Enter the Template Content"
      redirect_to template_campaign_path
      return

    else
      campaign = current_user.campaign.create
      campaign.project=Project.find(session[:project])

      emails=session[:valid_email]
      
      emails.each do |temail,tname|
        friend = campaign.campaign_friend.new
      
        friend.name = tname
        friend.email = temail
        friend.save
      end

      campaign.email_subject = session[:template_subject]
      campaign.template = session[:template_content]
      
      if session[:video_type] == 0
        campaign.video = Video.create(session[:video_link])
      elsif session[:video_type] == 1
        campaign.video = Video.create(:video_id => session[:video_link])
      end

      campaign.campaign_friend.each do |friend|
        friend.email_subject = campaign.email_subject
        friend.email_template = campaign.template
        friend.confirm_link= request.protocol+request.host_with_port+"/"+"campaigns/#{campaign.id}/confirm_watched?friend=#{friend.id}"
        friend.save
      end
      campaign.save
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
