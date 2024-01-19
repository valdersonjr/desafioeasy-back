class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :login, :name
end
