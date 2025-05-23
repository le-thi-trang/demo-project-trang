require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:user) { create(:user, name: 'ltieu.821') }
  let!(:project1) { create(:project, name: 'Alpha-Pro') }
  let!(:project2) { create(:project, name: 'Beta-Pro') }
  let!(:project3) { create(:project, name: 'Gam-Search') }

  describe 'GET /projects' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get projects_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'shows all projects if no search query' do
        get projects_path
        expect(response).to be_successful
        expect(response.body).to include('Alpha-Pro', 'Beta-Pro', 'Gam-Search')
      end

      it 'filters projects by search term' do
        get projects_path, params: { q: 'search' }
        expect(response.body).to include('Gam-Search')
        expect(response.body).not_to include('Alpha-Pro')
      end

      it 'is case-insensitive when searching' do
        get projects_path, params: { q: 'ALPHA' }
        expect(response.body).to include('Alpha-Pro')
      end

      context 'pagination' do
        before do
          Project.delete_all
          create_list(:project, 12)
        end

        it 'shows 10 projects on page 1' do
          get projects_path, params: { page: 1 }
          html = Nokogiri::HTML(response.body)
          rows = html.css('table tbody tr')
          expect(rows.size).to eq(10)
        end

        it 'shows remaining projects on page 2' do
          get projects_path, params: { page: 2 }
          html = Nokogiri::HTML(response.body)
          rows = html.css('table tbody tr')
          expect(rows.size).to eq(2)
        end
      end
    end
  end

  describe 'GET /projects/:id' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get project_path(project1)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      before { sign_in user }

      it 'shows the project' do
        get project_path(project1)
        expect(response).to be_successful
        expect(response.body).to include(project1.name)
      end
    end
  end
end
