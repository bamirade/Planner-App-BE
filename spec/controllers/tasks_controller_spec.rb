require 'simplecov'
SimpleCov.start 'rails'
require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all tasks' do
      task1 = FactoryBot.create(:task)
      task2 = FactoryBot.create(:task)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([task1, task2].as_json)
    end

    it 'returns tasks for a specific category' do
      category = FactoryBot.create(:category)
      task1 = FactoryBot.create(:task, category: category)
      task2 = FactoryBot.create(:task, category: category)

      get :index, params: { category_id: category.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([task1, task2].as_json)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      task = FactoryBot.create(:task)
      get :show, params: { id: task.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new task' do
        expect {
          post :create, params: { task: { name: 'Test Task', description: 'Test Description', due_date: Date.today, category_id: FactoryBot.create(:category).id } }
        }.to change(Task, :count).by(1)
      end

      it 'returns a created response' do
        post :create, params: { task: { name: 'Test Task', description: 'Test Description', due_date: Date.today, category_id: FactoryBot.create(:category).id } }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        post :create, params: { task: { name: nil, description: 'Test Description', due_date: Date.today, category_id: FactoryBot.create(:category).id } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested task' do
        task = FactoryBot.create(:task)
        new_name = 'New Task Name'

        patch :update, params: { id: task.to_param, task: { name: new_name } }
        task.reload

        expect(task.name).to eq(new_name)
      end

      it 'returns a success response' do
        task = FactoryBot.create(:task)
        patch :update, params: { id: task.to_param, task: { name: 'New Task Name' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        task = FactoryBot.create(:task)
        patch :update, params: { id: task.to_param, task: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      task = FactoryBot.create(:task)
      expect {
        delete :destroy, params: { id: task.to_param }
      }.to change(Task, :count).by(-1)
    end
  end
end
