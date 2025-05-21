require 'rails_helper'

RSpec.describe 'Members', type: :request do
  let(:user) { create(:user) }
  let!(:member1) { create(:member, name: 'Alice', phone_number: '123456789') }
  let!(:member2) { create(:member, name: 'Bob', phone_number: '987654321') }

  describe 'GET /members' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get members_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'shows all members if no search query' do
        get members_path
        expect(response).to be_successful
        expect(response.body).to include('Alice')
        expect(response.body).to include('Bob')
      end

      it 'filters members by search term' do
        get members_path, params: { q: 'Alice' }
        expect(response.body).to include('Alice')
        expect(response.body).not_to include('Bob')
      end

      it 'is case-insensitive when searching' do
        get members_path, params: { q: 'aLI' }
        expect(response.body).to include('Alice')
      end

      context 'pagination' do
        before do
          Member.delete_all
          create_list(:member, 12)
        end

        it 'shows 10 members on page 1' do
          get members_path, params: { page: 1 }
          html = Nokogiri::HTML(response.body)
          rows = html.css('table tbody tr')
          expect(rows.size).to eq(10)
        end

        it 'shows remaining members on page 2' do
          get members_path, params: { page: 2 }
          html = Nokogiri::HTML(response.body)
          rows = html.css('table tbody tr')
          expect(rows.size).to eq(2)
        end
      end
    end
  end
end
