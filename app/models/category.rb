class Category < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  default_scope { left_joins(:tasks).order(Arel.sql('COALESCE((SELECT MAX(tasks.due_date) FROM tasks WHERE tasks.category_id = categories.id), categories.created_at) DESC')) } unless Rails.env.test? || Rails.env.development? || Rails.env.production?
end
