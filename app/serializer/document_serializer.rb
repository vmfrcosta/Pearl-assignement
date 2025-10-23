class DocumentSerializer < ActiveModel::Serializer
  attributes :id, :name, :file_url, :metadata
end
