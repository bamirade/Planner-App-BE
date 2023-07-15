require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it 'validates the presence of name' do
      category = Category.new(name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many tasks' do
      category = Category.new(name: 'Work')
      expect(category.tasks).to be_empty

      task1 = category.tasks.build(name: 'Task 1')
      task2 = category.tasks.build(name: 'Task 2')

      expect(category.tasks).to include(task1, task2)
    end
  end
end
