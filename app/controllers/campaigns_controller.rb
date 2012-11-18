module CampaignHelper
    def check_session_farmer()
      if session[:project] ==nil
         flash[:error]="Please Select a Farmer"
         redirect_to farmer_campaign_path
         return
       end
    end

    def check_session_friends()
      if session[:valid_email] ==nil
        flash[:error]="Please Enter Some Valid Name and Email"
        redirect_to friends_campaign_path
        return
      end
    end

    def check_session_video()
      if session[:video_link] ==nil
        flash[:error]="Please Enter a Video Link"
        redirect_to video_campaign_path
        return
      end 
    end


    def check_session_template()
      if session[:template_subject] ==nil && session[:template_content]==nil
        flash[:error]="Please Enter the Subject and Content"
        redirect_to template_campaign_path
        return

      elsif session[:template_subject] ==nil
        flash[:error]="Please Enter the Template Subject"
        redirect_to template_campaign_path
        return

      elsif session[:template_content]==nil
        flash[:error]="Please Enter the Template Content"
        redirect_to template_campaign_path
        return
      end 
    end

    def reset_session
      session[:template_content]=nil
      session[:template_subject]=nil
      session[:project]=nil
      session[:valid_email]=nil
      session[:video_link]=nil
        
    end
end

class CampaignsController < ApplicationController
  before_filter :authenticate_user!
  #before_filter :check_owner, :only=>[:manger]
  include CampaignHelper

  def check_owner
    id = params[:id]
    #campaign = Campaign.find(id)
    if not campaign.user == current_user
      flash[:error] = "You may only view your campaigns"
      redirect_to dashboard_path
    end
  end

  def index
    #campaign = current_user.campaign.create
    campaign.project=nil
    campaign.save!
    redirect_to campaign_farmers_path(campaign)
	end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    flash[:notice] = "Campaign was Deleted Successfully"
    redirect_to dashboard_path
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
    #render :text => @projects.inspect
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
    valid_email_test=[]
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
        valid_email.push("error1, #{@name},#{email}")
        break
      elsif(@name.empty?)
        error_msg="Name field is incorrect for #{email}"
        valid_email.push("error2, #{@name},#{email}")
        break
      elsif(email.nil? ) 
        error_msg="Email field is incorrect for #{@name}" 
        valid_email.push("error3, #{@name},#{email}")
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
    check_session_friends
  end
  
  def submit_video
    session[:video_link]=params[:campaign][:video_link]    
    redirect_to template_campaign_path()
  end
  
  def template
    check_session_video
  end
  
  def submit_template
    session[:template_content]=params[:campaign][:template]
    session[:template_subject]=params[:campaign][:template_subject]
    
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

    campaign.campaign_friend.each do |friend|
      friend.email_subject = campaign.email_subject
      friend.email_template = campaign.template
      friend.email_template= "Hello #{friend.name} \n" + campaign.template + "\n \n My vidoe: #{campaign.video_link}"
      
      friend.confirm_link= request.protocol+request.host_with_port+"/"+"campaigns/#{campaign.id}/confirm_watched?friend=#{friend.id}"
      friend.email_template += "\n\n Please click the link Confirm you Watched my video: #{friend.confirm_link}"
      friend.save
    end
    campaign.save
    redirect_to manager_campaign_path(campaign)
    
  end

  def manager
    @campaign = Campaign.find(params[:id])
    @friends = @campaign.campaign_friend
    reset_campaign_session
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
  end
end
