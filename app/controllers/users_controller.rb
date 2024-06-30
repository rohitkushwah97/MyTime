class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[create] 
  before_action :get_user, only: [:show]
  def index
    @users = User.all
    render json: @users, each_serializer: UserSerializer
  end

  def show
    if @user.present?
      render json: { data: UserSerializer.new(@user) }, status: :ok
    else
      render json: { error: "User not found" }, status: :unprocessable_entity
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: { data: UserSerializer.new(@user), 
                     token: jwt_encode(user_id: @user.id),
                     message: 'User created successfully' }, status: :created, location: @user
    else
      render json: { errors: format_activerecord_errors(@user.errors) }, status: :unprocessable_entity
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

  def add_devices
    new_devices = (current_user.devices + user_params[:devices]).uniq
    current_user.update(devices: new_devices)
    render json: { message: "New devices added successfully" }, status: :ok
  end

  def remove_devices
    remaining_devices = current_user.devices - user_params[:devices]
    current_user.update(devices: remaining_devices)
    render json: { message: "Devices removed successfully" }, status: :ok
  end


  private

  def get_user
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.require(:data).permit(:email, :phone_number, :password, :full_name, :about_as, :profile_image, :notification_status, :contact_status, devices: [], address_attributes: [:id, :latitude, :longitude, :address, :_destroy])
  end
end
