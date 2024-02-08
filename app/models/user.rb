# Classe User (Usuário).

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher                    # Inclui a estratégia de revogação JWT JTIMatcher, para gerenciar tokens JWT.

    include LikeSearchable                                                 # Inclui o módulo LikeSearchable, adicionando a este modelo a capacidade de realizar buscas por correspondência de padrões.
    include Paginatable                                                    # Inclui o módulo Paginatable, adicionando funcionalidade de paginação a este modelo.

  devise :database_authenticatable, :registerable, :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null # Configura o Devise para usar autenticação de BD, registro, e autenticação JWT com uma estratégia de revogação.

  validates :login, presence: true, uniqueness: { case_sensitive: false }  # Valida a presença e unicidade (ignorando diferenças de maiúsculas/minúsculas) do login.
  validates :name, presence: true                                          # Valida a presença do nome.
  validates :password, presence: true, length: { minimum: 6 }, on: :create # Valida a presença da senha e exige um comprimento mínimo de 6 caracteres, mas apenas na criação do usuário.
end