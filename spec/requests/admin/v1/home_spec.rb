require "rails_helper"

describe "Home", type: :request do
  let(:user_attributes) { attributes_for(:user, login: "example", name: "Hygor", email: "test@test.com", password: "123456") }
  let(:user) { create(:user, user_attributes) }
  before do
    allow_any_instance_of(Admin::V1::HomeController).to receive(:authenticate_user!).and_return(true)
    allow_any_instance_of(Admin::V1::HomeController).to receive(:current_user).and_return(user)
  end

  it "tests home" do
    get '/admin/v1/home', headers: auth_header(user)
    expect(body_json).to eq({ 'message' => 'Uhul!' })
  end

  it "tests home" do
    get '/admin/v1/home', headers: auth_header(user)
    expect(response).to have_http_status(:ok)
  end

  private

  def auth_header(user)
    jwt_token = generate_jwt_token(user)
    {
      'Authorization' => "Bearer #{jwt_token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

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