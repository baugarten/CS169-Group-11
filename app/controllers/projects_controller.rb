class ProjectsController < ApplicationController
  before_filter :authenticate_admin!, :only => [:new, :edit, :create, :update, :destroy]

  require 'uri'
  require 'cgi'

  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new
    
    @video_extras = build_extras(@video_extras, params[:video_extras], :videos)
    @photo_extras = build_extras(@photo_extras, params[:photo_extras], :photos)

    respond_to do |format|
      format.html { render "_form" } # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find(params[:id])

    @video_extras = build_extras(@video_extras, params[:video_extras], :videos)
    @photo_extras = build_extras(@photo_extras, params[:photo_extras], :photos)
  end

  def build_extras(instancevar, param_val, key)
    instancevar = 1
    if param_val
      instancevar = param_val.to_i unless param_val.to_i < 1
    end
    instancevar.times do @project.send(key).build end
    return instancevar
  end

  def create
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        @video_extras = build_extras(@video_extras, params[:video_extras], :videos)
        @photo_extras = build_extras(@photo_extras, params[:photo_extras], :photos)
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.find(params[:id])
    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        @video_extras = build_extras(@video_extras, params[:video_extras], :videos)
        @photo_extras = build_extras(@photo_extras, params[:photo_extras], :photos)
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
  
  def donate
    @project = Project.find(params[:id])
    case params[:amount]
      when "10" then amount = 1000
      when "20" then amount = 2000
      when "other" then amount = parse_amount(params[:donation][:amount])
    end

    if (current_user)
      @donation = Donation.new({:amount=>amount, :email=>current_user.email})
    else
      @donation = Donation.new({:amount=>amount})
    end
    
    @stripe_public_key = ENV['STRIPE_PK']
  end
  
  def charge
    @project = Project.find(params[:id])
    
    @donation = Donation.new(params[:donation])
    
    @donation.project = @project
    if (current_user)
      @donation.user = current_user
    end
    
    charge = Stripe::Charge.create(
      :amount      => @donation.amount,
      :card        => params[:stripeToken],
      :description => "Donation for #{@project.farmer}",
      :currency    => 'usd'
    )
    @donation.stripe_charge_id = charge.id
    
    @donation.save!
    
    @project.update_current_donated

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to donate_project_path(params[:id])
  end

  private
  def parse_amount(amount)
    parse = /\$?(?<dollars>\d+)(.(?<cents>\d*))?/.match(amount)
    dollars = cents = 0
    if parse[:dollars]
      dollars = Integer(parse[:dollars])
    end
    if parse[:cents]
      cents = Integer(parse[:cents])
    end
    return (dollars * 100) + cents
  end
end

