require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'validates the presence of name' do
      task = FactoryBot.build(:task, name: nil)
      expect(task).not_to be_valid
      expect(task.errors[:name]).to include("can't be blank")
    end

    it 'validates the presence of description' do
      task = FactoryBot.build(:task, description: nil)
      expect(task).not_to be_valid
      expect(task.errors[:description]).to include("can't be blank")
    end

    it 'validates the presence of due_date' do
      task = FactoryBot.build(:task, due_date: nil)
      expect(task).not_to be_valid
      expect(task.errors[:due_date]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a category' do
      category = FactoryBot.create(:category)
      task = FactoryBot.create(:task, category: category)
      expect(task.category).to eq(category)
    end
  end
end
