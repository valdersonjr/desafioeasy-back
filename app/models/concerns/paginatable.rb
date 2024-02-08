# Módulo Paginatable que adiciona funcionalidade de paginação.

module Paginatable
  extend ActiveSupport::Concern

  MAX_PER_PAGE = 10                                                   # Constante que define o número máximo de registros por página.
  DEFAULT_PAGE = 1                                                    # Constante que define o número da página padrão, caso não seja especificada.

  included do                                                         # O bloco included é executado no contexto da classe que inclui o módulo.
    scope :paginate, -> (page, length) do                             # Define um escopo chamado :paginate que aceita dois parâmetros: page e length.
      page = page.present? && page > 0 ? page : DEFAULT_PAGE          # Determina a página atual. Se 'page' não estiver presente ou for menor que 1, usa DEFAULT_PAGE.
      length = length.present? && length > 0 ? length : MAX_PER_PAGE  # Determina o comprimento (número de registros por página). Se 'length' não estiver presente ou for menor que 1, usa MAX_PER_PAGE.
      starts_at = (page - 1) * length                                 # Calcula o índice do primeiro registro na página, com base na página atual e no comprimento.
      limit(length).offset(starts_at)                                 # Usa os métodos 'limit' e 'offset' do ActiveRecord para limitar o número de registros retornados e pular um certo número de registros, respectivamente, efetivamente paginando os resultados.
    end
  end
end 