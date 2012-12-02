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
    
    template_format_passed,error=template_format_pass(params[:campaign][:email_subject],params[:campaign][:template])
   
    if not template_format_passed
      flash[:error]=error
      redirect_to edit_campaign_path(@campaign)
      return
    end
    @campaign.email_subject = params[:campaign][:email_subject]
    @campaign.template = params[:campaign][:template]
    @campaign.save
    
    flash[:notice] = "Campaign was successfully updated"	
    redirect_to edit_campaign_path(@campaign)
  end
  
  def farmers
    reset_campaign_session
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
    redirect_to friends_campaign_path
  end

  def friends
    if fail_check_session_farmer()
      redirect_to campaign_farmers_path
    end
    if session[:email_list].nil? then session[:email_list] = [] end
    if params[:campaign] and params[:campaign][:email] 
      if not valid_email? params[:campaign][:email] or not valid_campaign_video?(params)
        flash[:error] = "Your last friend wasn't correct"
        @current = params[:campaign][:email]
      else
        fname, lname, email = parse_email(params[:campaign][:email])
        video_link, video_type = parse_campaign_video params
        if fname == '' and lname == '' then name = '' else name = %Q{#{fname} #{lname}} end
        session[:email_list] << CampaignFriend.new({
          :name => name,
          :email => email,
          :video => Video.new(:video_id => video_link)
        })
      end
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
      return
    end
    if session[:email_list].nil? || session[:email_list].empty? || session[:project] == nil 
      flash[:error] = %Q{Incomplete information to create a campaign #{session[:email_list]} #{session[:project]}} 
      redirect_to campaign_farmers_path
      return
    end
    email_list = session[:email_list].clone
    session.delete(:email_list)
    campaign = create_campaign(nil, session[:project], email_list,
                               session[:template_subject], session[:template_content])

    redirect_to manager_campaign_path(campaign)
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
end
