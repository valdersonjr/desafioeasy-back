# Código que estrutura um objeto JSON a partir de uma instância.

json.product do
  json.(@product, :id, :name, :ballast, :product_type) 
end