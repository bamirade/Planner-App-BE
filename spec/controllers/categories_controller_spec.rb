require 'simplecov'
SimpleCov.start 'rails'
require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all categories' do
      category1 = FactoryBot.create(:category)
      category2 = FactoryBot.create(:category)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([category1, category2].as_json)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      category = FactoryBot.create(:category)
      get :show, params: { id: category.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new category' do
        expect {
          post :create, params: { category: { name: 'Test Category' } }
        }.to change(Category, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { category: { name: 'Test Category' } }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        post :create, params: { category: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested category' do
        category = FactoryBot.create(:category)
        new_name = 'New Category Name'

        patch :update, params: { id: category.to_param, category: { name: new_name } }
        category.reload

        expect(category.name).to eq(new_name)
      end

      it 'returns a success response' do
        category = FactoryBot.create(:category)
        patch :update, params: { id: category.to_param, category: { name: 'New Category Name' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        category = FactoryBot.create(:category)
        patch :update, params: { id: category.to_param, category: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested category' do
      category = FactoryBot.create(:category)
      expect {
        delete :destroy, params: { id: category.to_param }
      }.to change(Category, :count).by(-1)
    end
  end
end
