class HomeController < ApplicationController
    def index
        @products = Products.all
        render json: @artists
    end
end