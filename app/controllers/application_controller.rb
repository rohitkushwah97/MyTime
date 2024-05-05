class ApplicationController < ActionController::Base
	protect_from_forgery with: :null_session
	# protect_from_forgery with: :null_session
	# include JsonWebToken
	# before_action :authenticate_request

	# private

	# def authenticate_request
  #   return if params[:controller].start_with?('admin/') || params[:controller].start_with?('active_admin/')
  #   begin
  #     token = request.headers['token']
  #     decoded = jwt_decode(token)
  #     byebug
  #     @current_user = MyDairy.find_by_id(decoded[:my_dairy_id]) || Customer.find_by_id(decoded[:customer_id] )
  #     raise ActiveRecord::RecordNotFound unless @current_user.present?
  #   rescue ActiveRecord::RecordNotFound => e
  #     render json: { errors: 'User not found' }, status: :unauthorized
  #   rescue JWT::DecodeError => e
  #     render json: { errors: 'Invalid token' }, status: :unauthorized
  #   end
  # end
end
