# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user, only: %i[edit update destroy]

  def index
    @search_name = search_params[:name]
    @users = if @search_name.present?
               User.where('LOWER(name) LIKE ?', "%#{@search_name.downcase}%")
             else
               User.all
             end

    @users = @users.order(created_at: 'desc').paginate(page: params[:page], per_page: 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: 'User created successfully.'
    else
      flash.now[:alert] = 'There were problems creating the user.'
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'User updated successfully.'
    else
      flash.now[:alert] = 'There were problems updating the user.'
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: 'User deleted successfully.'
    else
      redirect_to users_path, alert: 'There were problems deleting the user.'
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'User not found.'
  end

  def user_params
    params.require(:user).permit(:name, :email, :phone)
  end

  def search_params
    params.fetch(:search, {}).permit(:name)
  end
end
