# View de resposta em formato JSON.

# Esse bloco cria um array de objetos JSON.
# Cada objeto no array representa um registro retornado por @loading_service,
# incluindo apenas os campos :id, :code, e :delivery_date de cada registro.
json.loads do
  json.array! @loading_service.records, :id, :code, :delivery_date
end

# Esse bloco adiciona um objeto "meta" no JSON de resposta, que contém metadados de paginação.
# Ele faz isso utilizando um partial chamado 'shared/pagination', passando a ele a estrutura de paginação (@loading_service.pagination) que inclui informações como a página atual, total de páginas, etc.
json.meta do
  json.partial! 'shared/pagination', pagination: @loading_service.pagination
end