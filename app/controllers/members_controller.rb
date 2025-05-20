class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_member, only: %i[show edit update destroy]
  def index
    @members = Member.all
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

  private

  def set_member
    @member = Member.find(params[:id])
  end
end
