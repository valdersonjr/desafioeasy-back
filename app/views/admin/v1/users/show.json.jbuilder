# Código que estrutura um objeto JSON a partir de uma instância.

# Este bloco define a estrutura do JSON para o objeto @user.
# É esperado que @user seja uma instância de um modelo que contém informações que desejamos incluir na resposta JSON.
json.user do
  json.(@user, :id, :name, :login) # Resultado: um objeto JSON que contém apenas os valores dos atributos especificados, como "id": 123, "name": José, "login": José23.
end