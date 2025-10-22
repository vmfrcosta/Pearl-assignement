class Vault < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :knowledge, presence: true
end
