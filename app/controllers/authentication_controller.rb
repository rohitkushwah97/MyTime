class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request

  def login
    user = find_user_by_email_or_phone_number(params[:data][:email])
    if user.present?
      if user.authenticate(params[:data][:password])
        render_user_json(user)
      else
        render json: { errors: { password: 'Invalid Password' } }, status: :unauthorized
      end
    else
      render json: { errors: { email: 'Invalid Email/Phone Number' } }, status: :unauthorized
    end
  end

  private

  def find_user_by_email_or_phone_number(email)
    User.find_by("email = "+"'#{email}' or phone_number = "+"'#{email}'")
  end

  def render_user_json(user)
    render json: { token: jwt_encode(user_id: user.id), data: UserSerializer.new(user) }, status: :ok
  end
end
