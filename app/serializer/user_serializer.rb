class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :shareable_key
end
