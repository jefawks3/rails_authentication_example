class UserMailer < ApplicationMailer
  def password_reset
    @user = params.fetch :user
    @token = params.fetch(:token) { @user.generate_token_for :password_reset }

    mail subject: "Reset password", to: @user.email
  end
end
