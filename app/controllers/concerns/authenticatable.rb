require 'jwt'

module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    token = request.headers['Authorization'].to_s.split.last

    unless token.present? && valid_token?(token)
      Rails.logger.error("Authentication failed: Token missing or invalid")
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.devise_jwt_secret_key!, true, algorithm: 'HS256')
      Rails.logger.debug("Decoded Token: #{decoded_token}")

      user_id = decoded_token&.first&.fetch('user_id', nil)

      Rails.logger.debug("User ID from token: #{user_id}")

      @current_user = User.find(user_id)
      Rails.logger.info("Authentication successful: User found - #{@current_user.inspect}")

      true
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      false
    rescue JWT::VerificationError => e
      Rails.logger.error("JWT Verification Error: #{e.message}")
      false
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error("Record Not Found: #{e.message}")
      false
    end
  end
end