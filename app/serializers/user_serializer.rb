# Classe que é definida para serializar objetos do tipo User para o formato JSON.

class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :login, :name # Define quais atributos do objeto User devem ser incluídos na serialização.
end
