require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "password verification" do
    user = users(:test)
    assert user.authenticate("correct_password")
    assert_not user.authenticate("incorrect_password")
  end

  test "password_confirmation verification" do
    user = User.new password: "correct_password", password_confirmation: "bad_password"
    assert_not user.valid?

    user.password_confirmation = "correct_password"
    assert user.valid?
  end

  test "password_challenge verification" do
    user = users(:test)
    assert_not user.update(password: "new_password", password_confirmation: "new_password", password_challenge: "bad_password")
    assert user.errors.of_kind?(:password_challenge, :invalid)

    user.errors.clear
    assert user.update(password: "new_password", password_confirmation: "new_password", password_challenge: "correct_password")
    assert user.authenticate("new_password")
  end

  test "finds and authenticates by email and password" do
    user = users(:test)
    assert_nil User.authenticate_by(email: user.email, password: "bad_password")
    assert_equal user, User.authenticate_by(email: user.email, password: "correct_password")
  end

  test "has password reset token configuration" do
    assert User.token_definitions[:password_reset]
    assert_equal 10.minutes, User.token_definitions[:password_reset].expires_in
  end

  test "password reset token" do
    user = users(:test)
    token = user.generate_token_for :password_reset

    assert_equal user, User.find_by_token_for(:password_reset, token)

    travel 10.minutes + 1.seconds do
      assert_nil User.find_by_token_for(:password_reset, token)
    end

    user.update! password: "new_password", password_confirmation: "new_password"

    assert_nil User.find_by_token_for(:password_reset, token)
  end
end
