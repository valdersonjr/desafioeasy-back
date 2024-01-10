class Admin::V1::HomeController < ApplicationController
  def index
    render json: { message: 'Uhul!' }, status: :ok
  end
end