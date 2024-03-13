# Código que estrutura um objeto JSON a partir de uma instância.

json.user do
  json.(@user, :id, :name, :login) 
end