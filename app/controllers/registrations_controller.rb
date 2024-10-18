class RegistrationsController < ApplicationController
  before_action :user_not_authenticated!

  def new
    @user = User.new
  end

  def create
    user_params = params.require(:user).permit(:email, :password, :password_confirmation)
    @user = User.new user_params

    if @user.save
      sign_in @user
      redirect_to return_to_after_authentication_path || dashboards_path
    else
      render :new
    end
  end
end
