class MyTimeMailer < ApplicationMailer
  def send_otp(user,current_user)
    @user = user
    @otp = @user.otp
    @full_name = current_user.full_name
    mail(to: @user.email, subject: 'OTP Verification for Password forgot') do |format|
      format.html { render layout: 'mailer', template: 'forgot_passwords/send_otp' }
    end
  end
end
