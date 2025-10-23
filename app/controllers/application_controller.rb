class ApplicationController < ActionController::API
  private

  def render_authorization_error(message:)
    render json: { error: "Unauthorized: #{message}" }, status: :unauthorized
  end

  def authenticate(type: :private)
    @key ||= ApiKey.find_by(secret: request.headers['x-api-key'])
    message = nil
    if @key.blank?
      message = "key not found"
    elsif @key.shareable? && type == :private
      message = "key must be private"
    end

    { error: message.present?, message: message }
  end

  def public_authenticate
    auth = authenticate(type: :shareable)
    @error = auth[:error]
    @message = auth[:message]
  end

  def private_authenticate
    auth = authenticate
    @error = auth[:error]
    @message = auth[:message]
  end
end
