class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :vaults, dependent: :destroy
  has_many :api_keys, dependent: :destroy

  after_create :create_api_keys

  def private_key
    api_keys.find_by(shareable: false).secret
  end

  def shareable_key
    api_keys.find_by(shareable: true).secret
  end

  private

  def create_api_keys
    ApiKey.generate!(user: self, shareable: false)
    ApiKey.generate!(user: self, shareable: true)
  end
end
