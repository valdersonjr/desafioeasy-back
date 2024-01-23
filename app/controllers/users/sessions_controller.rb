class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    user = User.find_by(login: params[:user][:login])

    if user&.valid_password?(params[:user][:password])

      sign_in(user)
      token = request.env['warden-jwt_auth.token']

      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: { user: UserSerializer.new(user).as_json['data']['attributes'] },
        authentication_token: token
      }, status: :ok
    else
      Rails.logger.error("Authentication failed: Invalid login or password. User: #{params[:user][:login]}")
      render json: { error: 'Invalid login or password' }, status: :unauthorized
    end
  end

  private

  def respond_with(current_user, _opts = {})
    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      Rails.logger.debug("JWT Token in Authorization Header: #{jwt_payload}")
      current_user = User.find(jwt_payload['sub'])
    end
    
    if current_user
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end