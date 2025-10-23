class VaultSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :documents, serializer: DocumentSerializer
end
