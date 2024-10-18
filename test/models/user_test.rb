require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password verification" do
    user = users(:test)
    assert user.authenticate("correct_password")
    assert_not user.authenticate("incorrect_password")
  end

  test "password challenge verification" do
    user = User.create! email: "password-reset-#{SecureRandom.hex(4)}@example.com", password: "correct-password", password_confirmation: "correct-password"
    assert_not user.update(password: "new-password", password_confirmation: "new-password", password_challenge: "bad-password")
    assert user.errors.of_kind?(:password_challenge, :invalid)

    user.errors.clear
    assert user.update(password: "new-password", password_confirmation: "new-password", password_challenge: "correct-password")
    assert user.authenticate("new-password")
  end

  test "has password reset token configuration" do
    assert User.token_definitions[:password_reset]
    assert_equal 10.minutes, User.token_definitions[:password_reset].expires_in
  end

  test "password reset token" do
    user = User.create! email: "password-reset-#{SecureRandom.hex(4)}@example.com", password: "correct-password", password_confirmation: "correct-password"
    token = user.generate_token_for :password_reset

    assert_equal user, User.find_by_token_for(:password_reset, token)

    travel 10.minutes + 1.seconds do
      assert_nil User.find_by_token_for(:password_reset, token)
    end

    user.update! password: "new-password", password_confirmation: "new-password"

    assert_nil User.find_by_token_for(:password_reset, token)
  end
end
