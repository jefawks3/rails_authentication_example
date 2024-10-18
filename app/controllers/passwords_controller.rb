class PasswordsController < ApplicationController
  before_action :user_not_authenticated!
  before_action :find_user_from_token, only: [ :edit, :update ]

  def new; end

  def create
    email = params.require(:email)

    if (user = User.find_by(email:))
      UserMailer.with(user:).password_reset.deliver_now
    end
  end

  def edit; end

  def update
    @user.assign_attributes params.require(:user).permit(:password, :password_confirmation)

    if @user.save
      redirect_to new_sessions_path, notice: "Password reset"
    else
      flash.now[:alert] = "Unable to change your password."
      render "edit"
    end
  end

  def find_user_from_token
    @user = User.find_by_token_for :password_reset, params[:token]
    redirect_to new_passwords_path, alert: "Token expired" unless @user
  end
end
