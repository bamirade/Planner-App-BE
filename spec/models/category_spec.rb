require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it 'validates the presence of name' do
      category = FactoryBot.build(:category, name: nil)
      expect(category).not_to be_valid
      expect(category.errors[:name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many tasks' do
      category = FactoryBot.create(:category)
      task1 = FactoryBot.create(:task, category: category)
      task2 = FactoryBot.create(:task, category: category)
      expect(category.tasks).to include(task1, task2)
    end
  end
end
