class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
end
