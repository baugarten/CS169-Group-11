class ProjectsController < ApplicationController
  before_filter :authenticate_admin!, :except => [:index, :show]

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
    debugger
    if params[:project][:ending].to_i == 0 and not params[:project][:end_date].blank?
      params[:project][:end_date] = Date.strptime(params[:project][:end_date], '%m/%d/%Y') 
    end
    debugger
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
    if params[:project][:ending].to_i == 0 and not params[:project][:end_date].blank?
      params[:project][:end_date] = Date.strptime(params[:project][:end_date], '%m/%d/%Y') 
    end
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
end
