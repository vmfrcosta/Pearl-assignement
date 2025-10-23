class Vault < ApplicationRecord
  belongs_to :user
  has_many :documents, dependent: :destroy

  validates :name, presence: true
end
