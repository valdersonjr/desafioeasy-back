# Gerenciamento das operações CRUDs para o modelo Users (usuários).

module Admin::V1
  class UsersController < ApiController
    before_action :authenticate_user!                                                  
    before_action :load_user, only: [:show, :update, :destroy]                         

#   --AÇÕES DO CONTROLADOR--    
    def index                                                                          
      permitted = params.permit({ search: :name }, { order: {} }, :page, :length, :format)
      @loading_service = Admin::ModelLoadingService.new(User.all, searchable_params)
      @loading_service.call
    end

    def create                                                                        
      @user = User.new
      @user.attributes = user_params
      save_user!
    end

    def show; end                                                                     

    def update                                                                         
      @user.attributes = user_params
      save_user!
    end

    def destroy                                                                        
      if @user.id == current_user.id                                                   
        render_error({ message: "Você não pode excluir sua própria conta." })
        return
      end
      @user.destroy!
    rescue ActiveRecord::RecordNotDestroyed => e
      render_error(fields: @user.errors.messages.merge(base: [e.message]))
    end

    def current                                                                        
      render json: current_user
    end
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)  
    private

    def load_user                                                                      
      @user = User.find(params[:id])
    end

    def searchable_params                                                              
      cleaned_params = params.except(:format)
      cleaned_params.permit({ search: :name }, { order: {} }, :page, :length)
    end

    def user_params                                                                    
      return {} unless params.has_key?(:user)
      params.require(:user).permit(:id, :login, :name, :password)
    end

    def save_user!                                                                     
      @user.save!
      render :show
    rescue StandardError => e
      render_error(fields: @user.errors.messages.merge(base: [e.message]))
    end
  end
end