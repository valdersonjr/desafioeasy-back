module Admin::V1
    class OrderProductsController < ApiController
      before_action :authenticate_user!
      before_action :set_order, only: [:index, :create]
      before_action :load_order_product, only: [:show, :update, :destroy]
  
      def index
        @order_products = @order.order_products
        render json: @order_products, status: :ok
      end
  
      def create
        @order_product = @order.order_products.new(order_product_params)
        save_order_product!
      end
  
      def show; end
  
      def update
        @order_product.attributes = order_product_params
        save_order_product!
      end
  
      def destroy
        @order_product.destroy!
        head :no_content
      rescue
        render_error(fields: @order_product.errors.messages)
      end
  
      private
  
      def set_order
        @order = Order.find(params[:order_id])
      rescue ActiveRecord::RecordNotFound
        render_error(message: "Order not found", status: :not_found)
      end
  
      def load_order_product
        @order_product = OrderProduct.find(params[:id])
      end
  
      def order_product_params
        return {} unless params.has_key?(:order_product)
        params.require(:order_product).permit(:id, :product_id, :order_id ,:quantity, :box)
      end
  
      def save_order_product!
        @order_product.save!
        render :show, status: :created
      rescue StandardError => e
        render_error(fields: @order_product.errors.messages.merge(base: [e.message]))
      end
    end
  end