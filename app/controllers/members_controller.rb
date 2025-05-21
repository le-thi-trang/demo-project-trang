class MembersController < ApplicationController
  before_action :authenticate_user!
  def index
    @members = Member.order(created_at: :desc)
    q = "%#{params[:q].to_s.downcase}%"
    @members = @members.where('LOWER(name) LIKE ? OR LOWER(phone_number) LIKE ?', q, q)
    @members = @members.page(params[:page]).per(10)
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
