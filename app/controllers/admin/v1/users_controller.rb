# Gerenciamento das operações CRUDs para o modelo Users (usuários).

module Admin::V1
  class UsersController < ApiController
    before_action :authenticate_user!                                                  # Filtro para garantir que cada ação no controlador exija que o usuário esteja autenticado.
    before_action :load_user, only: [:show, :update, :destroy]                         # Filtro que chama o método load_user antes das ações show, update e destroy, carregando o objeto User correspondente ao id fornecido nos parâmetros das requisições.

#   --AÇÕES DO CONTROLADOR--    
    def index                                                                          # Index lista todos os objetos user aplicando ordenação e paginação, que são feitas através do serviço ModelLoadingService.
      permitted = params.permit({ search: :name }, { order: {} }, :page, :length)
      @loading_service = Admin::ModelLoadingService.new(User.all, searchable_params)
      @loading_service.call
    end

    def create                                                                         # Create cria um novo objeto user com os parâmetros fornecidos, tenta salvar no BD e renderiza a ação show em caso de sucesso, se falhar, renderiza um erro.
      @user = User.new
      @user.attributes = user_params
      save_user!
    end

    def show; end                                                                      # Show exibe o objeto user que foi carregado pelo filtro before_action :load_user.

    def update                                                                         # Update atualiza o objeto user carregado com os parâmetros fornecidos, tenta salvar as ações no banco de dados e renderiza a ação show em caso de sucesso, se falhar, renderiza um erro.
      @user.attributes = user_params
      save_user!
    end

    def destroy                                                                        # Destroy tenta deletar o objeto user carregado do BD, em caso de falha, renderiza um erro.
      if @user.id == current_user.id                                                   # Verifica se o usuário está tentando excluir ele mesmo, se estiver, renderiza a mensagem de erro.
        render_error({ message: "Você não pode excluir sua própria conta." })
        return
      end
      @user.destroy!
    rescue ActiveRecord::RecordNotDestroyed => e
      render_error(fields: @user.errors.messages.merge(base: [e.message]))
    end

    def current                                                                        # Current para receber o usuário atual que está logado e exibir seu nome no menu superior. 
      render json: current_user
    end
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)  
    private

    def load_user                                                                      # Carrega o objeto user com base no id fornecido para a requisição.
      @user = User.find(params[:id])
    end

    def searchable_params                                                              # Permite certos parâmetros para ações de busca e ordenação, para filtrar os dados na ação index.
      cleaned_params = params.except(:format)
      cleaned_params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def user_params                                                                    # Filtra os parâmetros permitidos para a criação ou atualização de um objeto user, evitando a atribuição em massa de parâmetros não permitidos.
      return {} unless params.has_key?(:user)
      params.require(:user).permit(:id, :login, :name, :password)
    end

    def save_user!                                                                     # Tenta salvar o objeto user no BD e renderiza a ação show em caso de sucesso. Em caso de erro, renderiza um erro com as mensagens de erro do objeto e qualquer exceção capturada.
      @user.save!
      render :show
    rescue StandardError => e
      render_error(fields: @user.errors.messages.merge(base: [e.message]))
    end
  end
end