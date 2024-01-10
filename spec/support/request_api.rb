require 'jwt'

module RequestAPI
  def body_json(symbolize_keys: false)
    json = JSON.parse(response.body)
    symbolize_keys ? json.deep_symbolize_keys : json
  rescue
    return {} 
  end

  def auth_header(user = nil, merge_with: {})
    user ||= create(:user)
    

    jwt_token = generate_jwt_token(user)
    
    header = { 
      'Authorization' => "Bearer #{jwt_token}",
      'Content-Type' => 'application/json', 
      'Accept' => 'application/json' 
    }
    
    header.merge merge_with
  end

  private

  def generate_jwt_token(user)

    secret_key = Rails.application.secrets.secret_key_base
    

    payload = { 
      user_id: user.id,
      username: user.login,

    }
    

    expiration_time = 1.hour.from_now.to_i
    options = { 
      exp: expiration_time,

    }
    

    JWT.encode(payload, secret_key, 'HS256', options)
  end
end

RSpec.configure do |config|
  config.include RequestAPI, type: :request
end