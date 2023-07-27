require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it 'has many tasks' do
      user = User.reflect_on_association(:tasks)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many categories' do
      user = User.reflect_on_association(:categories)
      expect(user.macro).to eq(:has_many)
    end

    it 'destroys associated tasks when deleted' do
      user = FactoryBot.create(:user)
      category = FactoryBot.create(:category, user: user)
      task = FactoryBot.create(:task, user: user, category: category)

      expect { user.destroy }.to change(Task, :count).by(-1)
    end

    it 'destroys associated categories when deleted' do
      user = FactoryBot.create(:user)
      FactoryBot.create_list(:category, 3, user: user)

      expect { user.destroy }.to change(Category, :count).by(-3)
    end
  end

  describe 'validations' do
    it 'validates the presence of email' do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'validates the uniqueness of email' do
      existing_user = FactoryBot.create(:user, email: 'test@example.com')
      user = FactoryBot.build(:user, email: 'test@example.com')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("has already been taken")
    end

    it 'validates the length of email' do
      user = FactoryBot.build(:user, email: 'a' * 256)
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("is too long (maximum is 255 characters)")
    end

    it 'validates the presence of password' do
      user = FactoryBot.build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'validates the minimum length of password' do
      user = FactoryBot.build(:user, password: 'abc12')
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end

    it 'validates the presence of password_confirmation when password is present' do
      user = FactoryBot.build(:user, password_confirmation: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("can't be blank")
    end
  end
end
