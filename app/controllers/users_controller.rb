class UsersController < ApplicationController
  before_action :private_authenticate, only: [:update, :destroy]
  def index
    users = params[:emails].present? ? User.where(email: params[:emails]) : User.all
    render json: users
  end

  def create
    render json: User.create!(user_params)
  end

  def update
    render json: { error: @message }, status: :unauthorized and return if @error

    user = User.find(params[:id])
    user.update!(user_params)

    render json: user
  end

  def destroy
    render json: { error: @message }, status: :unauthorized and return if @error
    user = User.find(params[:id])
    user.destroy!
    render json: { success: true }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
