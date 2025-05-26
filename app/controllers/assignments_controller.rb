class AssignmentsController < ApplicationController
  before_action :authenticate_user!

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
  end

  def destroy
  end

  private

  def assignment_params
    params.require(:assignment).permit(:project_id, :member_id, :role)
  end
end
