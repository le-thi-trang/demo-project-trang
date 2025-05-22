class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]
  def index
    @projects = Project.order(created_at: :desc)
    q = "%#{params[:q].to_s.downcase}%"
    @projects = @projects.where('LOWER(name) LIKE ?', q) if params[:q].present?
    @projects = @projects.page(params[:page]).per(10)
  end

  def show
    @assignment = Assignment.new
    @assignments = @project.assignments.order(created_at: :desc).includes(:member).page(params[:page]).per(5)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully destroyed.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :information, :deadline, :project_type, :status)
  end
end
