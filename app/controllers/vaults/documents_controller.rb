class Vaults::DocumentsController < ApplicationController
  before_action :private_authenticate, only: [:create, :update, :destroy]
  before_action :set_vault
  before_action :set_document, only: [:update, :destroy]
  def create
    render json: { error: @message }, status: :unauthorized and return if @error

    @document = @vault.documents.new(document_params)
    if document_params[:file].present?
      file = document_params[:file]
      @document.metadata = {
        'file_size' => file.size,
        'content_type' => file.content_type,
        'original_filename' => file.original_filename,
        'uploaded_at' => Time.now,
        'file_extension' => File.extname(file.original_filename),
        'user_agent' => request.user_agent,
        'ip_address' => request.remote_ip
      }

      storage_dir = Rails.root.join('storage', 'documents', @vault.id.to_s)
      FileUtils.mkdir_p(storage_dir)
      file_path = storage_dir.join(file.original_filename)

      File.open(file_path, 'wb') do |f|
        f.write(file.read)
      end

      @document.file_url = file_path.to_s
    end

    if @document.save
      render json: @document
    else
      render json: { errors: @document.errors }, status: :unprocessable_entity
    end
  end

  def update
    render json: { error: @message }, status: :unauthorized and return if @error

    old_file_path = @document.file_url

    @document = @vault.documents.new(document_params)
    if document_params[:file].present?
      file = document_params[:file]
      @document.metadata = {
        'file_size' => file.size,
        'content_type' => file.content_type,
        'original_filename' => file.original_filename,
        'uploaded_at' => Time.now,
        'file_extension' => File.extname(file.original_filename),
        'user_agent' => request.user_agent,
        'ip_address' => request.remote_ip
      }

      storage_dir = Rails.root.join('storage', 'documents', @vault.id.to_s)
      FileUtils.mkdir_p(storage_dir)
      file_path = storage_dir.join(file.original_filename)

      File.open(file_path, 'wb') do |f|
        f.write(file.read)
      end

      @document.file_url = file_path.to_s
    end

    if @document.save
      render json: @document
    else
      render json: { errors: @document.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    render json: { error: @message }, status: :unauthorized and return if @error

    @document.destroy!
    render json: { success: !@document.persisted? }
  end

  private

  def document_params
    params.require(:document).permit(:name, :file)
  end

  def set_vault
    @vault ||= Vault.find(params[:vault_id])
  end

  def set_document
    @document ||= Document.find(params[:id])
  end
end
