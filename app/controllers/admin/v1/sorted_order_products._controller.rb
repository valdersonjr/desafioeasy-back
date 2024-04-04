module Admin::V1
    class SortedOrderProductsController < ApiController
      before_action :authenticate_user!
      before_action :set_order, only: [:index, :show]

      def index; end 
      def show; end 

      private

      def set_order; end
    end
end