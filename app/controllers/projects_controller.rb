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
    @extras = 1
    if params[:extras]
      @extras = params[:extras].to_i unless params[:extras].to_i < 1
    end
    @extras.times do @project.videos.build end
    respond_to do |format|
      format.html { render "_form" } # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find(params[:id])
    @extras = 1
    if params[:extras]
      @extras = params[:extras].to_i unless params[:extras].to_i < 1
    end
    @extras.times do @project.videos.build end
  end

  def create
    @project = Project.new(params[:project])
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        @extras = 1
        @extras.times do @project.videos.build end
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
        @extras = 1
        @extras.times do @project.videos.build end
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
