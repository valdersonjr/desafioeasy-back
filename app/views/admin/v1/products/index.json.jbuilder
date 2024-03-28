# View de resposta em formato JSON.

json.products do
  json.array! @loading_service.records, :id, :name, :ballast, :product_type
end

json.meta do
  json.partial! 'shared/pagination', pagination: @loading_service.pagination
end