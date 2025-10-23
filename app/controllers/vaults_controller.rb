class VaultsController < ApplicationController
  before_action :private_authenticate, only: [:create, :update, :destroy]
  before_action :public_authenticate, only: [:index]
  before_action :render_error
  before_action :set_vault, only: [:update, :destroy]
  def index
    render json: Vault.where(user: @key.user)
  end

  def create
    render json: { error: @message }, status: :unauthorized and return if @error

    render json: Vault.create!(name: vault_params[:name], user: @key.user)
  end

  def update
    @vault.update!(vault_params)
    render json: @vault
  end

  def destroy
    @vault.destroy!
    render json: { success: !@vault.persisted? }
  end

  private

  def vault_params
    params.require(:vault).permit( :name)
  end

  def set_vault
    @vault ||= Vault.find(params[:id])
  end

  def render_error
    render json: { error: @message }, status: :unauthorized and return if @error
  end
end
