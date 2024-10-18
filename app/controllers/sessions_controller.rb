class SessionsController < ApplicationController
  before_action :user_not_authenticated!, only: [ :new, :create ]
  before_action :user_authenticated!, only: :destroy

  def new; end

  def create
    user_params = params.require(:user).permit(:email, :password)

    if (user = User.authenticate_by(user_params))
      sign_in user
      redirect_to return_to_after_authentication_path || dashboards_path, notice: "Welcome back"
    else
      flash.now[:alert] = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to new_sessions_path, notice: "Goodbye"
  end
end
