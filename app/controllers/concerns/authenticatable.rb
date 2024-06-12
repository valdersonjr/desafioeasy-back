# Módulo authenticatable para adicionar autenticação baseada em JWT.

require 'jwt'

module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!                                                                                    # Define um filtro before_action que chama o método authenticate_user! antes de cada ação em controllers que incluem este módulo.
  end
#   --MÉTODOS PRIVADOS-- (encapsulamentos que ajudam a proteger a lógica interna e aumentar a segurança do código)
  private

  def authenticate_user!
    token = request.headers['Authorization'].to_s.split.last                                                             # Extrai o token do cabeçalho 'Authorization' da requisição. Assume que o token vem após um espaço (como em "Bearer <token>").

    unless token.present? && valid_token?(token)                                                                         # Verifica se o token está presente e é válido. Se não, registra um erro e renderiza uma resposta JSON indicando não autorizado.
      Rails.logger.error("Authentication failed: Token missing or invalid")
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?(token)
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base!, true, algorithm: 'HS256')  # Decodifica o token JWT usando a chave secreta configurada e especificando o algoritmo HS256.
      Rails.logger.debug("Decoded Token: #{decoded_token}")

      user_id = decoded_token&.first&.fetch('user_id', nil)                                                              # Extrai o user_id do payload do token decodificado. Usado para encontrar o usuário correspondente.

      Rails.logger.debug("User ID from token: #{user_id}")

      @current_user = User.find(user_id)                                                                                 # Busca o usuário pelo ID extraído do token e define @current_user para ser usado em outras partes do aplicativo.
      Rails.logger.info("Authentication successful: User found - #{@current_user.inspect}")

      true # Retorna true se a autenticação for bem-sucedida.
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")                                                               # Captura e registra erros específicos de decodificação do JWT.
      false
    rescue JWT::VerificationError => e
      Rails.logger.error("JWT Verification Error: #{e.message}")
      false
    rescue ActiveRecord::RecordNotFound => e                                                                             # Captura e registra erros quando o usuário correspondente ao ID no token não é encontrado.
      Rails.logger.error("Record Not Found: #{e.message}")
      false
    end
  end
end