class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :categories, dependent: :destroy
  has_secure_password

  validates :email, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true, if: -> { password.present? }
end
