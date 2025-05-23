require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }
  let(:member) { create(:member) }
  let(:assignment) { create(:assignment, project: project, member: member, role: 'dev') }

  describe 'POST /projects/:project_id/assignments' do
    let(:valid_params) do
      {
        assignment: {
          project_id: project.id,
          member_id: member.id,
          role: 'dev'
        }
      }
    end

    context 'when signed in' do
      before do
        sign_in user, scope: :user
        post project_assignments_path(project), params: valid_params
      end
      it 'creates an assignment and redirects to the project page' do
        expect do
          post project_assignments_path(project), params: valid_params
        end.to change(Assignment, :count).by(1)
        expect(response).to redirect_to(project_path(project))
      end

      it 'assigns the correct project and member' do
        post project_assignments_path(project), params: valid_params
        expect(Assignment.last.project_id).to eq(project.id)
        expect(Assignment.last.member_id).to eq(member.id)
      end

      it 'assigns the correct role' do
        post project_assignments_path(project), params: valid_params
        expect(Assignment.last.role).to eq('dev')
      end

      it 'does not create an assignment with invalid params' do
        invalid_params = {
          assignment: {
            project_id: project.id,
            member_id: nil,
            role: ''
          }
        }
        expect do
          post project_assignments_path(project), params: invalid_params
        end.not_to change(Assignment, :count)
        expect(response).to redirect_to(project_path(project))
        follow_redirect!
        expect(flash[:alert]).to be_present
      end
    end
  end
end
