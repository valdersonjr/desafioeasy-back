# Referência para a criação de toda lógica de autênticação, login e criação de uma nova conta: https://sdrmike.medium.com/rails-7-api-only-app-with-devise-and-jwt-for-authentication-1397211fb97c
# Controller para realizar o processo de autenticação do Devise para trabalhar com JWT.

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix                                                                                         # Inclusão do RackSessionFix.
  respond_to :json                                                                                                # Especifica que este controller responde a requisições JSON.

  def create                                                                                                      # Método para criar (logar) um usuário.
    user = User.find_by(login: params[:user][:login])                                                             # Tenta encontrar um usuário pelo login fornecido nos parâmetros.
    if user&.valid_password?(params[:user][:password])                                                            # Se um usuário for encontrado e a senha for válida.

      sign_in(user) # Faz o login do usuário
      token = request.env['warden-jwt_auth.token']                                                                # Recupera o token JWT gerado pelo Warden, uma camada de autenticação usada pelo Devise.

      render json: {                                                                                              # Retorna um JSON com a mensagem de sucesso, dados do usuário e o token de autenticação.
        status: { code: 200, message: 'Logged in successfully.' },
        data: { user: UserSerializer.new(user).as_json['data']['attributes'] },
        authentication_token: token
      }, status: :ok
    else                                                                                                          # Se a autenticação falhar, loga o erro e retorna um JSON com a mensagem de erro.
      Rails.logger.error("Authentication failed: Invalid login or password. User: #{params[:user][:login]}")
      render json: { error: 'Invalid login or password' }, status: :unauthorized
    end
  end
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)
  private

  def respond_with(current_user, _opts = {})                                                                      # Sobrescrita do método respond_with para personalizar a resposta do login.
    render json: {
      status: { 
        code: 200, message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end

  def respond_to_on_destroy                                                                                       # Método personalizado para lidar com o logout.
    if request.headers['Authorization'].present?                                                                  # Verifica se existe um token JWT no cabeçalho Authorization.
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first # Decodifica o token para extrair o payload.
      Rails.logger.debug("JWT Token in Authorization Header: #{jwt_payload}")
      current_user = User.find(jwt_payload['sub'])                                                                # Encontra o usuário baseado no sub claim do token (user id).
    end
    
    if current_user                                                                                               # Se um usuário estiver logado, retorna uma mensagem de sucesso ao deslogar.
      render json: {
        status: 200,
        message: 'Logged out successfully.'
      }, status: :ok
    else                                                                                                          # Se não, retorna uma mensagem de erro indicando que não havia sessão ativa.
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
end