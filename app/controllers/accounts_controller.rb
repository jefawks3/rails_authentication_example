class AccountsController < ApplicationController
  before_action :user_authenticated!

  def show; end

  def update
    user_params = params.require(:user).permit(:email)

    if current_user.update user_params
      flash.now[:notice] = "Updates saved"
    else
      flash.now[:alert] = "Unable to save changes"
    end

    render "show"
  end

  def change_password
    user_params = params.require(:user).permit(:password, :password_confirmation, :password_challenge)

    if current_user.update user_params
      flash.now[:notice] = "Password changed"
    else
      flash.now[:alert] = "Unable to change password"
    end

    render "show"
  end
end
