class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :login]

  def create
    user = User.new(user_params)

    if user.save
      render json: { token: AuthHelper.generate_token(user.id) }, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:user][:email])

    if user&.authenticate(params[:user][:password])
      render json: { token: AuthHelper.generate_token(user.id) }
    else
      render_unauthorized
    end
  end

  def show
    user = User.find(params[:id])
    render json: user
  rescue ActiveRecord::RecordNotFound
    render json: { error: "User not found" }, status: :not_found
  end

  def update
    user = User.find(params[:id])

    if user == @current_user
      if user.update(user_params)
        render json: user
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  def destroy
    user = User.find_by(id: params[:id])

    if user == @current_user
      user.destroy
      head :no_content
    else
      render_unauthorized
    end
  end

  def update_password
    user = User.find(params[:id])

    if user == @current_user
      if user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
        render json: { message: 'Password updated successfully' }
      else
        render json: user.errors, status: :unprocessable_entity
      end
    else
      render_unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
