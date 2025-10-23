class ApiKey < ApplicationRecord
  belongs_to :user

  validates :secret, presence: true, uniqueness: true
  validates :shareable, uniqueness: { scope: :user }

  def self.generate!(user:, shareable: true)
    create!(user: user, secret: SecureRandom.hex(32), shareable: shareable)
  end

  def private?
    !shareable
  end

  def shareable?
    shareable
  end
end
