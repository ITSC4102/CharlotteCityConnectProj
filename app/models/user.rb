class User < ApplicationRecord
  has_secure_password
  has_many :events, dependent: :destroy

  attribute :reg_events, :integer, array: true, default: []

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
end
