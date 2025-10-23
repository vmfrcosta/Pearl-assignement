class Document < ApplicationRecord
  belongs_to :vault
  has_one_attached :file

  validates :name, presence: true
  validates :file, presence: true
  validates :metadata, presence: true


end
