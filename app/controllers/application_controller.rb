# Controller que configura os parâmetros permitidos para as ações de autenticação do Devise.

class ApplicationController < ActionController::API
    before_action :configure_permitted_parameters, if: :devise_controller?                                         # Define um filtro que é executado antes de cada ação nos controllers que herdam deste.
                                                                                                                   # O filtro só é aplicado se o controller for um controller do Devise, graças à condição `if: :devise_controller?`.
#   --MÉTODOS PROTEGIDOS--     
protected
    
    def configure_permitted_parameters                                                                             # Permite parâmetros adicionais para a ação :sign_up do Devise.
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :login, :password, :password_confirmation])        # Necessário por ter campos extras que precisam ser aceitos na criação de um usuário, como name e login, além dos campos padrões password e password_confirmation.
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :login, :password, :password_confirmation]) # Permite os mesmos parâmetros adicionais para a ação :account_update, permitindo que os usuários atualizem suas informações.
    end
  end
  