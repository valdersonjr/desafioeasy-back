module Admin::V1
  class LoadsController < ApiController
    
    before_action :load_load, only: [:show, :update, :destroy]
    before_action :build_load, only: [:create, :update]
    before_action :authenticate_user!
    def index
      @loading_service = Admin::ModelLoadingService.new(Load.all, searchable_params)
      @loading_service.call
    end

    def create
      @load = Load.new
      @load.attributes = load_params
      save_load!
    end

    def show; end

    def update
      @load.attributes = load_params
      save_load!
    end

    def destroy
      @load.destroy!
    rescue
      render_error(fields: @load.errors.messages)
    end

    private

    def build_load
      @load = params[:id] ? Load.find(params[:id]) : Load.new
      @load.attributes = load_params
    end

    def load_load
      @load = Load.find(params[:id])
    end

    def searchable_params
      params.permit({ search: :code }, { order: {} }, :page, :length)
    end

    def load_params
      return {} unless params.has_key?(:load)
      params.require(:load).permit(:id, :code, :delivery_date)
    end

    def save_load!
      @load.save!
      render :show
    rescue StandardError => e
      render_error(fields: @load.errors.messages.merge(base: [e.message]))
    end
  end
end
