# Gerenciamento das operações CRUDs para o modelo Products (produtos).

module Admin::V1
  class ProductsController < ApiController
    before_action :authenticate_user!                                                  
    before_action :load_product, only: [:show, :update, :destroy]                      

#   --AÇÕES DO CONTROLADOR--    
    def index                                                                          
      permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
      @loading_service = Admin::ModelLoadingService.new(Product.all, searchable_params)
      @loading_service.call
    end

    def create                                                                         
      @product = Product.new
      @product.attributes = product_params
      save_product!
    end

    def show; end                                                                      

    def update                                                                         
      @product.attributes = product_params
      save_product!
    end

    def destroy                                                                        
      @product.destroy!
    rescue
      render_error(fields: @product.errors.messages)
    end
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)
    private 

    def load_product                                                                   
      @product = Product.find(params[:id])
    end

    def searchable_params                                                              
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def product_params                                                                 
      return {} unless params.has_key?(:product)
      params.require(:product).permit(:id, :name, :ballast)
    end

    def save_product!                                                                 
      @product.save!
      render :show
    rescue StandardError => e
      render_error(fields: @product.errors.messages.merge(base: [e.message]))
    end
  end
end
