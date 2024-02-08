# Gerenciamento das operações CRUDs para o modelo Loads (cargas).

module Admin::V1
  class LoadsController < ApiController    
    before_action :authenticate_user!                                                  # Filtro para garantir que cada ação no controlador exija que o usuário esteja autenticado.   
    before_action :load_load, only: [:show, :update, :destroy]                         # Filtro que chama o método load_load antes das ações show, update e destroy, carregando o objeto Load correspondente ao id fornecido nos parâmetros das requisições. 

#   --AÇÕES DO CONTROLADOR--
    def index                                                                          # Index lista todos os objetos load aplicando ordenação e paginação, que são feitas através do serviço ModelLoadingService.
      permitted = params.permit({ search: :code }, { order: {} }, :page, :length)
      @loading_service = Admin::ModelLoadingService.new(Load.all, searchable_params)
      @loading_service.call
    end
    
    def create                                                                         # Create cria um novo objeto load com os parâmetros fornecidos, tenta salvar no BD e renderiza a ação show em caso de sucesso, se falhar, renderiza um erro.
      @load = Load.new
      @load.attributes = load_params
      save_load!
    end

    def show; end                                                                      # Show exibe o objeto load que foi carregado pelo filtro before_action :load_load.

    def update                                                                         # Update atualiza o objeto load carregado com os parâmetros fornecidos, tenta salvar as ações no banco de dados e renderiza a ação show em caso de sucesso, se falhar, renderiza um erro.
      @load.attributes = load_params
      save_load!
    end

    def destroy                                                                        # Destroy tenta deletar o objeto load carregado do BD, em caso de falha, renderiza um erro.
      @load.destroy!
    rescue
      render_error(fields: @load.errors.messages)
    end
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)
    private 

    def load_load                                                                      # Carrega o objeto load com base no id fornecido para a requisição.
      @load = Load.find(params[:id])
    end

    def searchable_params                                                              # Permite certos parâmetros para ações de busca e ordenação, para filtrar os dados na ação index.
      params.permit({ search: :code }, { order: {} }, :page, :length)
    end

    def load_params                                                                    # Filtra os parâmetros permitidos para a criação ou atualização de um objeto load, evitando a atribuição em massa de parâmetros não permitidos.
      return {} unless params.has_key?(:load)
      params.require(:load).permit(:id, :code, :delivery_date)
    end

    def save_load!                                                                     # Tenta salvar o objeto load no BD e renderiza a ação show em caso de sucesso. Em caso de erro, renderiza um erro com as mensagens de erro do objeto e qualquer exceção capturada.
      @load.save!
      render :show
    rescue StandardError => e
      render_error(fields: @load.errors.messages.merge(base: [e.message]))
    end
  end
end
