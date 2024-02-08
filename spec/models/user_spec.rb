# Modelo user para testes.

require 'rails_helper'

RSpec.describe User, type: :model do
    it_has_behavior_of "like searchable concern", :user, :name           # Verifica se o modelo User pode ser pesquisado por meio de uma consulta 'like' pelo atributo :name.
    it_behaves_like "paginatable concern", :user                         # Verifica se o modelo User pode ser paginado de acordo com os critérios definidos no concern 'paginatable'.

    it { is_expected.to validate_presence_of(:login)}                    # Verifica se o modelo User valida a presença do atributo :login. 
    it { is_expected.to validate_uniqueness_of(:login).case_insensitive} # Verifica se o modelo User valida a unicidade do atributo :login, sem considerar diferenças entre maiúsculas e minúsculas.
    it { is_expected.to validate_presence_of(:name)}                     # Verifica se o modelo User valida a presença do atributo :name. 
    it { is_expected.to validate_presence_of(:password) }                # Verifica se o modelo User valida a presença do atributo :password. 
    it { is_expected.to validate_length_of(:password).is_at_least(6) }   # Verifica se o modelo User valida a presença do atributo :password e se ele é possui pelo menos 6 caracteres. 
end