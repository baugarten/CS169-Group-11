module CampaignHelper
    def check_session_farmer()
      
      if session[:project] ==nil
         reset_session
         flash[:error]="Please Select a Farmer"
         redirect_to farmer_campaign_path
         return
       end
      session[:template_content]=nil
      session[:template_subject]=nil
      session[:valid_email]=nil
      session[:video_link]=nil
      session[:email_list]=nil
    end

    def check_session_friends()
      if session[:valid_email] ==nil
        flash[:error]="Please Enter Some Valid Name and Email"
        redirect_to friends_campaign_path
        return
      end
    end

    def check_session_video()
      if session[:video_link] ==nil || session[:video_link].empty?
        flash[:error]="Please Enter a Video Link"
        redirect_to video_campaign_path
        return
      end 
    end

    def reset_session
      session[:template_content]=nil
      session[:template_subject]=nil
      session[:project]=nil
      session[:valid_email]=nil
      session[:video_link]=nil
      session[:email_list]=nil
    end
end

class CampaignsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:confirm_watched]
  before_filter :check_owner, :except=>[:new,:confirm_watched]

  def check_owner
    id = params[:id]
    campaign = Campaign.find(id)
    if campaign==nil
      flash[:error] = "Campaigns with id:#{params[:id]} doesnt exist!!"
      redirect_to dashboard_path
       
    elsif not campaign.user == current_user
      flash[:error] = "You may only view your campaigns"
      redirect_to dashboard_path
    end
  end

  def new
    redirect_to campaign_farmers_path()
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
    error_msg =""
    session[:email_list]=params[:campaign][:email_list]

    email_list=params[:campaign][:email_list]
    email_friends_count=0
    valid_email={}
    
    email_list.scan(/[\s]?([\w\s]+)<([\s+\w+\.\@]+)>+/).each do | m |
      @name=""
      m[0].nil? ? temp0="" : temp0=m[0]
      temp0.scan(/\s*([a-zA-Z]+)/).each do|t|   
        if not t[0].nil?
          @name.empty? ? @name += t[0] : @name +=" "+ t[0]
        end
      end
      
      email=m[1]
      if not email.nil?
        #delete all spaces in email front& end, not including spaces between any two characters
        email=email.gsub(/(^\s+|\s+$)/,"")
        #check validation,email=nil if not valid email
        email =email.match(/^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i) 
      end
      
      #error_msg cases
      if(@name.empty? && email.nil?)
        error_msg="name field  and email field "
        break
      elsif(@name.empty?)
        error_msg="Name field is incorrect for #{email}"
        break
      elsif(email.nil? ) 
        error_msg="Email field is incorrect for #{@name}" 
        break
      end

      valid_email["#{email}"]="#{@name}"
    end
    
 
    session[:valid_email]=valid_email unless valid_email.size ==0
    
  
    if error_msg !=""
      flash[:error] = error_msg
      redirect_to friends_campaign_path()
    else
      redirect_to video_campaign_path
    end
  end
  
  def video
    @campaign = Campaign.find(params[:id])
  end
  
  def submit_video
    campaign = Campaign.find(params[:id])
    if params[:video] == 'recorded' and params[:videos].nil? or 
      params[:video] == 'link' and params[:campaign][:video_link].blank?
      redirect_to video_campaign_path(campaign)
      return
    end

    if params[:video] == 'recorded'
      video = Video.create(params[:videos]["0"])
    else
      video = Video.create({ :video_id => params[:campaign][:video_link] })
    end
    campaign.video = video
    campaign.save
    
    redirect_to template_campaign_path(campaign)
  end
  
  def template
    @campaign = Campaign.find(params[:id])
  end
  
  def submit_template

    campaign = Campaign.find(params[:id])
    campaign.email_subject = params[:campaign][:email_subject]
    campaign.template = params[:campaign][:template]
    campaign.save
    

    campaign.campaign_friend.each do |friend|
      friend.email_subject = campaign.email_subject
      friend.email_template = campaign.template

      friend.confirm_link= request.protocol+request.host_with_port+"/"+"campaigns/#{campaign.id}/confirm_watched?friend=#{friend.id}"

      friend.save
    end


    redirect_to manager_campaign_path(campaign)
  end
  
  def manager
    @campaign = Campaign.find(params[:id])
    @friends = @campaign.campaign_friend
  end

  def track
     @campaign = Campaign.find(params[:id])
     
     @friend=@campaign.campaign_friend.find(params[:friend])
     @friend.sent_count=@friend.sent_count+1
     @friend.save
  end

  def confirm_watched
     @campaign = Campaign.find(params[:id])
     @friend=@campaign.campaign_friend.find(params[:friend])
     if @friend.sent_count>0
        @friend.opened= @friend.opened+1

     else
        @friend.opened=0 
     end
     @friend.save
     redirect_to @campaign.video_link
  end
end
