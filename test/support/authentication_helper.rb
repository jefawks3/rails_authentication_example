# frozen_string_literal: true

module AuthenticationHelper
  def sign_in(email:, password:)
    post sessions_url, params: { user: { email:, password: } }
  end

  def create_and_sign_in(attributes = {})
    attributes[:email] ||= "test-#{SecureRandom.hex(8)}"
    attributes[:password] ||= "correct-password"
    attributes[:password_confirmation] = attributes[:password]

    user = User.create! attributes
    sign_in_with user
    user
  end

  def sign_in_with(user, password: nil)
    password ||= user.password
    sign_in(email: user.email, password:)
  end

  def sign_out
    delete sessions_url
  end
end

ActiveSupport.on_load :action_dispatch_integration_test do
  include AuthenticationHelper
end
