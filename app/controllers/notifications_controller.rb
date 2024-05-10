class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show destroy]

  def index
    @notifications = current_user.notifications_created_for
    render json: { data: @notifications }, status: :ok
  end

  def show
    render json: { data: @notification }, status: :ok
  end

  def destroy
    @notification.destroy
    render json: { message: 'Notification was successfully destroyed.' }, status: :ok
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Notification not found' }, status: :unprocessable_entity
  end
end
