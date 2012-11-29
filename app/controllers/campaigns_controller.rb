class CampaignsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:index,:manager,:destroy,:edit,:update]
  before_filter :authenticate_admin!, :only =>  [:index]
  before_filter :check_owner, :only=>[:manager,:destroy,:edit,:update]
  include CampaignsHelper

  def check_owner
    if not admin_signed_in?
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
  end

  def index
     @campaign = Campaign.find(:all)
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
    else
      if params[:video] == 'recorded'
        session[:video_link]=params[:videos]["0"]
        session[:video_type]="webcam"
      else
        session[:video_link]=params[:campaign][:video_link]
        session[:video_type]="link"
      end
  
      redirect_to template_campaign_path()
    end
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
      campaign=create_campaign(nil,session[:project],session[:valid_email],session[:template_subject],session[:template_content],session[:video_type],session[:video_link])

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
     email_body=@friend.email_body
     email_subject=@friend.email_subject
     email_body=html_symbol_process(email_body)
     email_subject=html_symbol_process(email_subject)
     email="mailto:#{@friend.email}?subject=#{email_subject}&body=#{email_body}"

     respond_to do |format|
       format.html { redirect_to email}
     end
    
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
