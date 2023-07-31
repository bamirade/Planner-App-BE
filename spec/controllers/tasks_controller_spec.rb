require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let(:current_user) { FactoryBot.create(:user) }
  let(:token) { AuthHelper.generate_token(current_user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET #index' do
    it 'returns a success response' do
      request.headers.merge!(headers)
      get :index
      expect(response).to be_successful
    end

    it 'returns all tasks for the current user' do
      request.headers.merge!(headers)
      category = FactoryBot.create(:category, user: current_user)
      task1 = FactoryBot.create(:task, user: current_user, category: category)
      task2 = FactoryBot.create(:task, user: current_user, category: category)

      get :index

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([task1, task2].as_json)
    end

    it 'returns tasks for a specific category if category_id is provided' do
      request.headers.merge!(headers)
      category1 = FactoryBot.create(:category, user: current_user)
      category2 = FactoryBot.create(:category, user: current_user)
      task1 = FactoryBot.create(:task, user: current_user, category: category1)
      task2 = FactoryBot.create(:task, user: current_user, category: category2)

      get :index, params: { category_id: category1.id }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([task1].as_json)
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      request.headers.merge!(headers)
      category = FactoryBot.create(:category, user: current_user)
      task = FactoryBot.create(:task, user: current_user, category: category)
      get :show, params: { id: task.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new task' do
        request.headers.merge!(headers)
        category = FactoryBot.create(:category, user: current_user)
        expect {
          post :create, params: { task: { name: 'Test Task', description: 'Test Description', due_date: Date.tomorrow, category_id: category.id } }
        }.to change(Task, :count).by(1)
      end

      it 'returns a created response' do
        request.headers.merge!(headers)
        category = FactoryBot.create(:category, user: current_user)
        post :create, params: { task: { name: 'Test Task', description: 'Test Description', due_date: Date.tomorrow, category_id: category.id } }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        request.headers.merge!(headers)
        post :create, params: { task: { name: nil, description: 'Test Description', due_date: Date.tomorrow } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the requested task' do
        request.headers.merge!(headers)
        category = FactoryBot.create(:category, user: current_user)
        task = FactoryBot.create(:task, user: current_user, category: category)
        new_name = 'New Task Name'

        patch :update, params: { id: task.to_param, task: { name: new_name } }
        task.reload

        expect(task.name).to eq(new_name)
      end

      it 'returns a success response' do
        request.headers.merge!(headers)
        category = FactoryBot.create(:category, user: current_user)
        task = FactoryBot.create(:task, user: current_user, category: category)
        patch :update, params: { id: task.to_param, task: { name: 'New Task Name' } }
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      it 'returns an unprocessable entity response' do
        request.headers.merge!(headers)
        category = FactoryBot.create(:category, user: current_user)
        task = FactoryBot.create(:task, user: current_user, category: category)
        patch :update, params: { id: task.to_param, task: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested task' do
      request.headers.merge!(headers)
      category = FactoryBot.create(:category, user: current_user)
      task = FactoryBot.create(:task, user: current_user, category: category)
      expect {
        delete :destroy, params: { id: task.to_param }
      }.to change(Task, :count).by(-1)
    end
  end
end
