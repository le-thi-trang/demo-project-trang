# frozen_string_literal: true

# ProjectsController handles the CRUD operations for projects in the application.
# It allows users to create, read, update, and delete project records.
# The controller also includes search functionality for projects by name.
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]
  def index
    @projects = Project.order(created_at: :desc)
    if params[:q].present?
      q = "%#{params[:q].to_s.downcase}%"
      @projects = @projects.where('LOWER(name) LIKE ?', q)
    end
    @projects = @projects.page(params[:page]).per(10)
  end

  def show
    @assignments = @project.assignments.order(created_at: :desc).includes(:member).page(params[:page]).per(5)

    @assignment = if params[:assignment_id].present?
                    Assignment.find_by(id: params[:assignment_id])
                  else
                    Assignment.new
                  end
  end

  def new
    @project = Project.new
  end

  def edit; end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to projects_path, notice: 'Project was successfully created.'
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path, notice: 'Project was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @project.assignments.destroy_all
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully destroyed.'
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.expect(project: %i[name information deadline project_type status])
  end
end
