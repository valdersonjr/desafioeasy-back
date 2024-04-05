module Admin::V1
    class SortedOrderProductsController < ApiController
      before_action :authenticate_user!
      before_action :set_order, only: [:index]

      def index
        order_products = @order.order_products
        sorted_products = sort_order_products(order_products)
        render json: sorted_products, status: :ok
      end

      private

      def set_order
        @order = Order.find(params[:order_id])
      rescue ActiveRecord::RecordNotFound
        render_error(message: "Lista não encontrada", status: :not_found)
      end

      def sort_order_products(order_products)
        order_products.sort_by { |product| -product[:quantity] }
      end
    end
end