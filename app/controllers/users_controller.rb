class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create] 

  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer
  end

  def show
    render json: { data: UserSerializer.new(current_user) }, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { data: UserSerializer.new(@user), 
                     token: jwt_encode(user_id: @user.id),
                     message: 'User created successfully' }, status: :created, location: @user
    else
      render json: { errors: format_activerecord_errors(current_user.errors) }, status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(user_params)
      render json: { data: UserSerializer.new(current_user) }
    else
      render json: { errors: format_activerecord_errors(current_user.errors) }, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user.destroy
      render json: { message: 'User delete successfully' }, status: :ok
    else
      render json: { errors: 'Failed to deleted' }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:data).permit(:email, :phone_number, :password, :full_name, :about_as, :address_id)
  end
end
