module Admin::V1
  class OrdersController < ApiController    
    before_action :authenticate_user!                                                  
    before_action :load_order, only: [:show, :update, :destroy]                        

    def index
      orders_query = if params[:load_id]
      Load.find(params[:load_id]).orders
        else
      Order.all
        end
      @loading_service = Admin::ModelLoadingService.new(orders_query, searchable_params)
      @loading_service.call
    end
    
    def create
      @order = Order.new
      @order.attributes = order_params
      save_order!
    end

    def show
      order = Order.find(params[:id])
      render json: order, include: [:order_products], status: :ok
    end

    def update
      @order.attributes = order_params
      save_order!
    end

    def destroy
      @order.destroy!
    rescue
      render_error(fields: @order.errors.messages)
    end

    private

    def load_order
      @order = Order.find(params[:id])
    end

    def searchable_params
      params.permit(:load_id, { search: :code }, { order: {} }, :page, :length, :format)
    end

    def order_params
      return {} unless params.has_key?(:order)
      params.require(:order).permit(:id, :code, :bay, :load_id)
    end

    def save_order!
      @order.save!
      render :show
    rescue StandardError => e
      render_error(fields: @order.errors.messages.merge(base: [e.message]))
    end
  end
end