module Admin::V1
  class HomeController < ApiController
  before_action :authenticate_user!
  def index
    render json: { message: 'Uhul!' }
    end
  end
end