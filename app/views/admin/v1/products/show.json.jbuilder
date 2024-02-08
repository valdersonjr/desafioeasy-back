# Código que estrutura um objeto JSON a partir de uma instância.

# Este bloco define a estrutura do JSON para o objeto @product.
# É esperado que @product seja uma instância de um modelo que contém informações que desejamos incluir na resposta JSON.
json.product do
  json.(@product, :id, :name, :ballast) # Resultado: um objeto JSON que contém apenas os valores dos atributos especificados, como "id": 123, "name": Coca-cola, "ballast": 4.
end