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
          12.times do |i|
            create(:member, name: "Member-#{i + 1}")
          end
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

  describe 'GET /members/new' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get new_member_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'renders the new member form' do
        get new_member_path
        expect(response).to be_successful
        expect(response.body).to include('Create member')
      end
    end
  end

  describe 'POST /members' do
    context 'when signed in' do
      before do
        sign_in user
      end

      it 'creates a new member with valid attributes' do
        expect do
          post members_path,
               params: { member: { name: 'Charlie', phone_number: '5555555555', date_of_birth: '1990-01-01', position: 'pm',
                                   information: 'Lorem ipsum' } }
        end.to change(Member, :count).by(1)
        expect(response).to redirect_to(members_path)
        follow_redirect!
        expect(response.body).to include('Member was successfully created.')
      end

      it 'does not create a member with invalid attributes' do
        expect do
          post members_path, params: { member: { name: '', phone_number: '1234555555', date_of_birth: '1990-01-01', position: 'pm',
                                                 information: 'Lorem ipsum' } }
        end.not_to change(Member, :count)
        expect(response.body).to include('Create member')
        expect(response.body).to include('error')
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET /members/:id' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get member_path(member1)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'shows the member details' do
        get member_path(member1)
        expect(response).to be_successful
        expect(response.body).to include(member1.name)
      end
    end
  end

  describe 'GET /members/:id/edit' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        get edit_member_path(member1)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'renders the edit member form' do
        get edit_member_path(member1)
        expect(response).to be_successful
        expect(response.body).to include('Update member')
      end
    end
  end

  describe 'PATCH /members/:id' do
    context 'when signed in' do
      before do
        sign_in user
      end

      it 'updates the member' do
        patch member_path(member1), params: { member: { name: 'Ali', phone_number: '123456789', date_of_birth: '1990-01-01', position: 'pm',
                                                        information: 'Lorem ipsum' } }

        expect(response).to redirect_to(members_path)
        follow_redirect!
        expect(response.body).to include('Member was successfully updated.')
        expect(member1.reload.name).to eq('Ali')
      end

      it 'does not update the member with invalid attributes' do
        patch member_path(member1), params: { member: { name: '', phone_number: '1234555555', date_of_birth: '1990-01-01', position: 'pm',
                                                        information: 'Lorem ipsum' } }
        expect(response.body).to include('Update member')
        expect(response.body).to include('error')
        expect(response).to render_template(:edit)
        expect(member1.reload.name).not_to eq('')
      end
    end
  end

  describe 'DELETE /members/:id' do
    context 'when not signed in' do
      it 'redirects to sign in page' do
        delete member_path(member1)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      before do
        sign_in user
      end

      it 'deletes the member' do
        expect do
          delete member_path(member1)
        end.to change(Member, :count).by(-1)
        expect(response).to redirect_to(members_path)
        follow_redirect!
        expect(response.body).to include('Member was successfully destroyed.')
      end
    end

    context 'does not delete the member and shows alert' do
      before do
        sign_in user
        allow_any_instance_of(Member).to receive(:destroy).and_return(false)
      end

      it 'does not delete the member' do
        expect do
          delete member_path(member1)
        end.not_to change(Member, :count)
        expect(response).to redirect_to(members_path)
        follow_redirect!
        expect(flash[:alert]).to eq(member1.errors.full_messages.to_sentence)
      end
    end
  end
end
