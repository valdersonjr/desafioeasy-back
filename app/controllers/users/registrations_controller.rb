# Referência para a criação de toda lógica de autênticação, login e criação de uma nova conta: https://sdrmike.medium.com/rails-7-api-only-app-with-devise-and-jwt-for-authentication-1397211fb97c
# Controller que personaliza a resposta ao registrar um novo usuário.

class Users::RegistrationsController < Devise::RegistrationsController
  include RackSessionsFix                                                                                              # Inclui o RackSessionsFix que é a parte em que o devise cria um hash de sessão falso.
  respond_to :json                                                                                                     # Define que este controller responde a requisições JSON.
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)  
  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?                                                                                             # Verifica se o usuário foi persistido no banco de dados com sucesso.
      render json: {
        status: {code: 200, message: 'Signed up successfully.'},                                                       # Se o usuário foi criado com sucesso, renderiza um JSON com uma mensagem de sucesso e os atributos do usuário serializados.
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
    else
      render json: {                                                                                                   # Se o usuário não foi criado com sucesso, renderiza um JSON com uma mensagem de erro.
        status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end