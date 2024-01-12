json.users do
    json.array! @loading_service.records, :id, :name, :login, :email
  end
  
  json.meta do
    json.partial! 'shared/pagination', pagination: @loading_service.pagination
  end