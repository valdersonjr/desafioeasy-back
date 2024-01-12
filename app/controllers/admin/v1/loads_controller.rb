module Api::V1
    class LoadsController < ApplicationController
      before_action :authorize_access_request!, except: [:show, :index]
      before_action :set_load, only: %i[ show update destroy ]
      before_action :authenticate_user!

      # GET /loads
      def index
        @loads = Load.all

        render json: @loads
      end

      # GET /loads/1
      def show
        render json: @load
      end

      # POST /loads
      def create
        @load = Load.new(load_params)

        if @load.save
          render json: @load, status: :created, location: @load
        else
          render json: @load.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /loads/1
      def update
        if @load.update(load_params)
          render json: @load
        else
          render json: @load.errors, status: :unprocessable_entity
        end
      end

      # DELETE /loads/1
      def destroy
        @load.destroy
      end

      private
        # Use callbacks to share common setup or constraints between actions.
        def set_load
          @load = Load.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def load_params
          params.require(:load).permit(:code, :delivery_date)
        end
    end
  end