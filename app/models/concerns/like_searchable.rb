# Esse módulo adiciona um escopo like que pode ser usado para realizar pesquisas simples baseadas em correspondência de padrões no banco de dados.

module LikeSearchable
  extend ActiveSupport::Concern

  included do
    scope :like, -> (key, value) do
      self.where(self.arel_table[key].matches("%#{value}%"))
    end
  end
end