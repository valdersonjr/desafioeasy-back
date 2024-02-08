# Classe Product (Produto).

class Product < ApplicationRecord                                          # Define a classe Product como um modelo ActiveRecord, herança que permite interagir com a tabela 'products' no BD.

    include LikeSearchable                                                 # Inclui o módulo LikeSearchable, adicionando a este modelo a capacidade de realizar buscas por correspondência de padrões.
    include Paginatable                                                    # Inclui o módulo Paginatable, adicionando funcionalidade de paginação a este modelo.

    validates :name, presence: true, uniqueness: { case_sensitive: false } # Valida a presença e a unicidade (ignorando diferenças de maiúsculas/minúsculas) do atributo name.
                                                                           # Isso garante que cada produto tenha um nome e que não haja dois produtos com o mesmo nome,
                                                                           # independentemente de capitalização.
    validates :ballast, presence: true, numericality: { greater_than: 0 }  # Valida a presença do atributo :ballast, garantindo que cada produto tenha um valor especificado para este campo e
                                                                           # adiciona uma restrição lógica ao modelo que faz com que ballast seja numérico e maior que zero.
end
