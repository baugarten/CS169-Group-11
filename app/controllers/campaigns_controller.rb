class CampaignsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :check_owner, :except=>[:new]

  def check_owner
    id = params[:id]
    campaign = Campaign.find(id)
    if not campaign.user == current_user
      flash[:error] = "You may only view your campaigns"
      redirect_to dashboard_path
    end
  end

  def new
    campaign = current_user.campaign.create
    campaign.project=nil
    campaign.save!

    redirect_to(farmers_campaign_path(campaign))
	end

  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    flash[:notice] = "Campaign was deleted successfully"
    redirect_to dashboard_path
  end
  
  def farmers
    id = params[:id]
    @campaign = Campaign.find(id)

    @existed_projects=Campaign.all(:conditions=>["user_id=?",current_user.id])
    result=[]
    @existed_projects .each do|campaign|
      if campaign != nil && campaign.project!=nil
        result.push(campaign.project.id)
      end
    end
    @projects=Project.find(:all, :conditions => ["id NOT IN (?)", result])
  end
  
  def select_farmer
    campaign = Campaign.find(params[:id])
    project = Project.find(params[:farmer])
    
    campaign.project = project
    campaign.save!
    
    redirect_to friends_campaign_path(campaign)
  end
  
  def friends
    @campaign = Campaign.find(params[:id])
    
  end
  
  def submit_friends
    campaign = Campaign.find(params[:id])
    emails = params[:campaign][:email_list].split(",")
    
    failed = false
    error = "Unable to understand these emails: <br/>"
    
    # clear friends before adding entire list
    campaign.campaign_friend.clear
    
    emails.each do |email|
      friend = campaign.campaign_friend.new
      if (email =~ /\s*(.*)\s*<(.*)>/)
        friend.name = $1
        friend.email = $2
        friend.save
      else
        if failed
          error += ", "
        end
        error += "#{email}"
        failed = true
      end
    end
    
    if failed
      flash[:error] = error
      redirect_to friends_campaign_path(campaign)
    else
      redirect_to video_campaign_path(campaign)
    end
  end
  
  def video
    @campaign = Campaign.find(params[:id])
  end
  
  def submit_video
    campaign = Campaign.find(params[:id])
    campaign.video_link = params[:campaign][:video_link]
    campaign.save
    
    redirect_to template_campaign_path(campaign)
  end
  
  def template
    @campaign = Campaign.find(params[:id])
  end
  
  def submit_template
    # save campaign-wide template
    campaign = Campaign.find(params[:id])
    campaign.email_subject = params[:campaign][:email_subject]
    campaign.template = params[:campaign][:template]
    campaign.save
    
    # propagage to each individual friend
    campaign.campaign_friend.each do |friend|
      friend.email_subject = campaign.email_subject
      friend.email_template = campaign.template
      friend.email_template= "Hello #{friend.name} \n" + campaign.template + "\n \n My vidoe: #{campaign.video_link}"
      
      friend.confirm_link= request.protocol+request.host_with_port+"/"+"campaigns/#{campaign.id}/confirm_watched?friend=#{friend.id}"
      friend.email_template += "\n\n Please click the link Confirm you Watched my video: #{friend.confirm_link}"
      friend.save
    end
    
    #redirect_to send_emails_campaign_path(campaign)
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
  end
end
