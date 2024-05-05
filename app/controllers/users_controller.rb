class UsersController < ApplicationController
  # skip_before_action :authenticate_request, only: %i[create] 
  before_action :set_user, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer
  end

  def show
    render json: @user, serializer: UserSerializer
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, serializer: UserSerializer
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :phone_number, :password_digest, :full_name, :about_as, :address_id)
  end

  def render_not_found
    render json: { error: 'User not found' }, status: :not_found
  end
end
