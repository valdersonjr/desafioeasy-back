# Gerenciamento das operações CRUDs para o modelo Products (produtos).

module Admin::V1
  class ProductsController < ApiController
    before_action :authenticate_user!                                                  # Filtro para garantir que cada ação no controlador exija que o usuário esteja autenticado. 
    before_action :load_product, only: [:show, :update, :destroy]                      # Filtro que chama o método load_product antes das ações show, update e destroy, carregando o objeto Product correspondente ao id fornecido nos parâmetros das requisições.

#   --AÇÕES DO CONTROLADOR--    
    def index                                                                          # Index lista todos os objetos product aplicando ordenação e paginação, que são feitas através do serviço ModelLoadingService.
      permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
      @loading_service = Admin::ModelLoadingService.new(Product.all, searchable_params)
      @loading_service.call
    end

    def create                                                                         # Create cria um novo objeto product com os parâmetros fornecidos, tenta salvar no BD e renderiza a ação show em caso de sucesso, se falhar, renderiza um erro.
      @product = Product.new
      @product.attributes = product_params
      save_product!
    end

    def show; end                                                                      # Show exibe o objeto product que foi carregado pelo filtro before_action :load_product.

    def update                                                                         # Update atualiza o objeto product carregado com os parâmetros fornecidos, tenta salvar as ações no banco de dados e renderiza a ação show em caso de sucesso, se falhar, renderiza um erro.
      @product.attributes = product_params
      save_product!
    end

    def destroy                                                                        # Destroy tenta deletar o objeto product carregado do BD, em caso de falha, renderiza um erro.
      @product.destroy!
    rescue
      render_error(fields: @product.errors.messages)
    end
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)
    private 

    def load_product                                                                   # Carrega o objeto product com base no id fornecido para a requisição.
      @product = Product.find(params[:id])
    end

    def searchable_params                                                              # Permite certos parâmetros para ações de busca e ordenação, para filtrar os dados na ação index.
      params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def product_params                                                                 # Filtra os parâmetros permitidos para a criação ou atualização de um objeto product, evitando a atribuição em massa de parâmetros não permitidos.
      return {} unless params.has_key?(:product)
      params.require(:product).permit(:id, :name, :ballast)
    end

    def save_product!                                                                  # Tenta salvar o objeto product no BD e renderiza a ação show em caso de sucesso. Em caso de erro, renderiza um erro com as mensagens de erro do objeto e qualquer exceção capturada.
      @product.save!
      render :show
    rescue StandardError => e
      render_error(fields: @product.errors.messages.merge(base: [e.message]))
    end
  end
end
