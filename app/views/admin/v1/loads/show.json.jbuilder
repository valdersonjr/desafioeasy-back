# Código que estrutura um objeto JSON a partir de uma instância.

# Este bloco define a estrutura do JSON para o objeto @load.
# É esperado que @load seja uma instância de um modelo que contém informações que desejamos incluir na resposta JSON.
json.load do
  json.(@load, :id, :code, :delivery_date) # Resultado: um objeto JSON que contém apenas os valores dos atributos especificados, como "id": 123, "code": ABC123, "delivery_date": 2022-05-23.
end