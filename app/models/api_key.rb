class ApiKey < ApplicationRecord
  belongs_to :user

  validates :secret, presence: true
  validates :shareable, presence: true, uniqueness: { scope: :user }

  def self.generate!(user:, shareable: true)
    create!(user: user, secret: SecureRandom.hex(32), shareable: shareable)
  end
end
