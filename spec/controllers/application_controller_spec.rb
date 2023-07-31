require 'simplecov'
SimpleCov.start 'rails'

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  describe 'authentication' do
    it 'returns unauthorized for missing token' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized for invalid token' do
      request.headers['Authorization'] = 'invalid_token'
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized for expired token' do
      user = FactoryBot.create(:user)
      expired_token = AuthHelper.generate_token(user.id)

      token_with_expired_time = JWT.encode({ user_id: user.id, exp: Time.now.to_i - 3600 }, AuthHelper::SECRET_KEY, 'HS256')
      request.headers['Authorization'] = "Bearer #{token_with_expired_time}"

      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'assigns current_user for valid token' do
      user = FactoryBot.create(:user)
      valid_token = AuthHelper.generate_token(user.id)
      request.headers['Authorization'] = "Bearer #{valid_token}"
      get :index
      expect(assigns(:current_user)).to eq(user)
    end
  end
end
