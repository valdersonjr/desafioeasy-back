# Classe Load (Carga).

class Load < ApplicationRecord                                             # Define a classe Load como um modelo ActiveRecord, herança que permite interagir com a tabela 'loads' no BD.
    has_many :orders

    include LikeSearchable                                                 # Inclui o módulo LikeSearchable, adicionando a este modelo a capacidade de realizar buscas por correspondência de padrões.
    include Paginatable                                                    # Inclui o módulo Paginatable, adicionando funcionalidade de paginação a este modelo.

    validates :code, presence: true, uniqueness: { case_sensitive: false } # Valida a presença e a unicidade (não sensível a maiúsculas e minúsculas) do atributo code.
    validates :delivery_date, presence: true                               # Valida a presença do atributo delivery_date, garantindo que cada carga tenha uma data de entrega.
end
