# frozen_string_literal: true

# AssignmentsController handles the CRUD operations for assignments in the application.
# It allows users to create, update, and delete assignments for projects.
# The controller also includes authentication to ensure only signed-in users can manage assignments.
class AssignmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_assignment, only: %i[update destroy]
  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to project_path(@assignment.project), notice: 'Assignment was successfully created.'
    else
      redirect_to project_path(@assignment.project), alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to project_path(@assignment.project), notice: 'Assignment was successfully updated.'
    else
      redirect_to project_path(@assignment.project), alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @assignment.destroy
    redirect_to project_path(@assignment.project), notice: 'Assignment was successfully destroyed.'
  end

  private

  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.expect(assignment: %i[project_id member_id role])
  end
end
