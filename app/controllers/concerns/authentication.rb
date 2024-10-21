# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :user_signed_in?
  end

  def current_user
    @current_user ||= authenticate_user
  end

  def user_signed_in?
    current_user.present?
  end

  def sign_in(user)
    reset_session
    session[:user_id] = user.id
  end

  def sign_out
    @current_user = nil
    session.delete :user_id
    reset_session
  end

  def user_authenticated!
    return if user_signed_in?

    session[:return_to_after_authentication] = request.fullpath
    redirect_to new_sessions_path
  end

  def return_to_after_authentication_path
    session.delete :return_to_after_authentication
  end

  def user_not_authenticated!
    redirect_to dashboards_path if user_signed_in?
  end

  private

  def authenticate_user
    if (id = session[:user_id])
      User.find id
    end
  end
end
