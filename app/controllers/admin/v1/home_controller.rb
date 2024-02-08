module Admin::V1
  class HomeController < ApiController
  before_action :authenticate_user!
# Mensagem para teste da rota "home".  
  def index
    render json: { message: 'Uhul!' }
    end
  end
end