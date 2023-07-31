require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:current_user) { FactoryBot.create(:user) }
  let(:token) { AuthHelper.generate_token(current_user.id) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) { attributes_for(:user) }

      it 'creates a new user' do
        expect {
          post :create, params: { user: valid_params }
        }.to change(User, :count).by(1)
      end

      it 'returns a status of :created' do
        post :create, params: { user: valid_params }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { attributes_for(:user, email: nil) }

      it 'does not create a new user' do
        expect {
          post :create, params: { user: invalid_params }
        }.to_not change(User, :count)
      end

      it 'returns a status of :unprocessable_entity' do
        post :create, params: { user: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #login' do
    let!(:user) { create(:user) }

    context 'with valid credentials' do
      it 'returns a token' do
        post :login, params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized' do
        post :login, params: { user: { email: user.email, password: 'wrong_password' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #show' do
    let!(:user) { create(:user) }

    context 'with valid user id' do
      it 'returns the user details' do
        request.headers.merge!(headers)
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['email']).to eq(user.email)
      end
    end

    context 'with invalid user id' do
      it 'returns not found' do
        request.headers.merge!(headers)
        get :show, params: { id: 'invalid_id' }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user) }
    let(:tokens) { AuthHelper.generate_token(user.id) }
    let(:headers) { { 'Authorization' => "Bearer #{tokens}" } }

    context 'with valid parameters' do
      it 'updates the user email' do
        request.headers.merge!(headers)
        new_email = Faker::Internet.email
        password = user.password
        patch :update, params: { id: user.id, user: { email: new_email, password: password, password_confirmation: password } }
        user.reload
        expect(response).to have_http_status(:success)
        expect(user.email).to eq(new_email)
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        request.headers.merge!(headers)
        patch :update, params: { id: user.id, user: { email: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when trying to update a different user' do
      let!(:other_user) { create(:user) }
      let(:other_user_tokens) { AuthHelper.generate_token(other_user.id) }
      let(:other_user_headers) { { 'Authorization' => "Bearer #{other_user_tokens}" } }

      it 'returns unauthorized' do
        request.headers.merge!(other_user_headers)
        new_email = Faker::Internet.email
        password = user.password
        patch :update, params: { id: user.id, user: { email: new_email, password: password, password_confirmation: password } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    let(:tokens) { AuthHelper.generate_token(user.id) }
    let(:headers) { { 'Authorization' => "Bearer #{tokens}" } }

    context 'with valid user id' do
      it 'destroys the user' do
        request.headers.merge!(headers)
        expect {
          delete :destroy, params: { id: user.id }
        }.to change(User, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'with invalid user id' do
      it 'returns not found' do
        request.headers.merge!(headers)
        delete :destroy, params: { id: 'invalid_id' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PATCH #update_password' do
    let!(:user) { create(:user) }
    let(:tokens) { AuthHelper.generate_token(user.id) }
    let(:headers) { { 'Authorization' => "Bearer #{tokens}" } }

    context 'with valid parameters' do
      it 'updates the user password' do
        request.headers.merge!(headers)
        new_password = Faker::Internet.password(min_length: 8)
        patch :update_password, params: {
          id: user.id,
          user: {
            password: new_password,
            password_confirmation: new_password
          }
        }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body)['message']).to eq('Password updated successfully')
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity' do
        request.headers.merge!(headers)
        patch :update_password, params: {
          id: user.id,
          user: {
            password: 'short',
            password_confirmation: 'short'
          }
        }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when trying to update password for a different user' do
      let!(:other_user) { create(:user) }
      let(:other_user_tokens) { AuthHelper.generate_token(other_user.id) }
      let(:other_user_headers) { { 'Authorization' => "Bearer #{other_user_tokens}" } }

      it 'returns unauthorized' do
        request.headers.merge!(other_user_headers)
        new_password = Faker::Internet.password(min_length: 8)
        patch :update_password, params: {
          id: user.id,
          user: {
            password: new_password,
            password_confirmation: new_password
          }
        }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
