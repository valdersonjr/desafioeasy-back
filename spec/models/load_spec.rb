# Modelo load para testes.

require 'rails_helper'

RSpec.describe Load, type: :model do
    it_has_behavior_of "like searchable concern", :load, :code           # Verifica se o modelo Load pode ser pesquisado por meio de uma consulta 'like' pelo atributo :code.
    it_behaves_like "paginatable concern", :load                         # Verifica se o modelo Load pode ser paginado de acordo com os critérios definidos no concern 'paginatable'.

    it { is_expected.to validate_presence_of(:delivery_date)}            # Verifica se o modelo Load valida a presença do atributo :delivery_date. 
    it { is_expected.to validate_presence_of(:code)}                     # Verifica se o modelo Load valida a presença do atributo :code. 
    it { is_expected.to validate_uniqueness_of(:code).case_insensitive}  # Verifica se o modelo Load valida a unicidade do atributo :code, sem considerar diferenças entre maiúsculas e minúsculas.
end