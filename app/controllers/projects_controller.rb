class ProjectsController < ApplicationController
  before_action :authenticate_user!
  def index
    @projects = Project.order(created_at: :desc)
    q = "%#{params[:q].to_s.downcase}%"
    @projects = @projects.where('LOWER(name) LIKE ?', q) if params[:q].present?
    @projects = @projects.page(params[:page]).per(10)
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
