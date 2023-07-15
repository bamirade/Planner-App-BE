require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validations' do
    it 'validates the presence of name' do
      task = Task.new(name: nil, description: 'Task description', due_date: Date.today, category_id: 1)
      expect(task).not_to be_valid
      expect(task.errors[:name]).to include("can't be blank")
    end

    it 'validates the presence of description' do
      task = Task.new(name: 'Task name', description: nil, due_date: Date.today, category_id: 1)
      expect(task).not_to be_valid
      expect(task.errors[:description]).to include("can't be blank")
    end

    it 'validates the presence of due_date' do
      task = Task.new(name: 'Task name', description: 'Task description', due_date: nil, category_id: 1)
      expect(task).not_to be_valid
      expect(task.errors[:due_date]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a category' do
      category = Category.create(name: 'Work')
      task = category.tasks.build(name: 'Task 1', description: 'Task description', due_date: Date.today)

      expect(task.category).to eq(category)
    end
  end
end
