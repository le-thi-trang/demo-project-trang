# frozen_string_literal: true

# MembersController handles the CRUD operations for members in the application.
# It allows users to create, read, update, and delete member records.
# The controller also includes search functionality for members by name or phone number.
class MembersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_member, only: %i[show edit update destroy]
  def index
    @members = Member.order(created_at: :desc)
    q = "%#{params[:q].to_s.downcase}%"
    @members = @members.where('LOWER(name) LIKE ? OR LOWER(phone_number) LIKE ?', q, q)
    @members = @members.page(params[:page]).per(10)
  end

  def show; end

  def new
    @member = Member.new
  end

  def edit; end

  def create
    @member = Member.new(member_params)
    if @member.save
      redirect_to members_path, notice: 'Member was successfully created.'
    else
      render :new
    end
  end

  def update
    if @member.update(member_params)
      redirect_to members_path, notice: 'Member was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @member.destroy
      redirect_to members_path, notice: 'Member was successfully destroyed.'
    else
      redirect_to members_path, alert: @member.errors.full_messages.to_sentence
    end
  end

  private

  def set_member
    @member = Member.find(params[:id])
  end

  def member_params
    params.expect(member: %i[name phone_number date_of_birth position information avatar])
  end
end
