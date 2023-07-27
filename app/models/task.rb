class Task < ApplicationRecord
  belongs_to :user
  belongs_to :category

  validates :name, presence: true
  validates :description, presence: true
  validates :due_date, presence: true

  attribute :is_completed, :boolean, default: -> { false }
end
