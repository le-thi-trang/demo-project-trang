class MembersController < ApplicationController
  before_action :authenticate_user!
  def index
    @members = Member.order(created_at: :desc)
    q = "%#{params[:q].to_s.downcase}%"
    @members = @members.where('LOWER(name) LIKE ? OR LOWER(phone_number) LIKE ?', q, q)
    @members = @members.page(params[:page]).per(10)
  end

  def show
    @member = Member.find(params[:id])
    @form_method = :get
  end

  def new
    @member = Member.new
    @form_method = :post
  end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to members_path, notice: 'Member was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def member_params
    params.require(:member).permit(:name, :phone_number, :date_of_birth, :position, :information, :avatar)
  end
end
