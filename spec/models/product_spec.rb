# Modelo product para testes.

require 'rails_helper'

RSpec.describe Product, type: :model do
    it_has_behavior_of "like searchable concern", :product, :name              # Verifica se o modelo Product pode ser pesquisado por meio de uma consulta 'like' pelo atributo :name.
    it_behaves_like "paginatable concern", :product                            # Verifica se o modelo Product pode ser paginado de acordo com os critérios definidos no concern 'paginatable'.

    it { is_expected.to validate_presence_of(:name)}                           # Verifica se o modelo Product valida a presença do atributo :name. 
    it { is_expected.to validate_presence_of(:ballast)}                        # Verifica se o modelo Product valida a presença do atributo :ballast. 
    it { is_expected.to validate_numericality_of(:ballast).is_greater_than(0)} # Verifica se o modelo Product valida a unicidade do atributo :ballast, onde ele tem que ser maior que zero.
end