class Category < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50 }
  validates :user_id, uniqueness: { scope: :name, message: "should have a unique name" }
end
