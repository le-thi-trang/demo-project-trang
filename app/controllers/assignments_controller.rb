class AssignmentsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to project_path(@assignment.project_id), notice: 'Assignment was successfully created.'
    else
      redirect_to project_path(@assignment.project_id), alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def assignment_params
    params.require(:assignment).permit(:project_id, :member_id, :role)
  end
end
