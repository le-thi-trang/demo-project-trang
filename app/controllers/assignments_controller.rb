class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assignment, only: %i[update destroy]
  def index
  end

  def show
  end

  def new
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to project_path(@assignment.project), notice: 'Assignment was successfully created.'
    else
      redirect_to project_path(@assignment.project), alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to project_path(@assignment.project), notice: 'Assignment was successfully updated.'
    else
      redirect_to project_path(@assignment.project), alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:project_id, :member_id, :role)
  end
end
