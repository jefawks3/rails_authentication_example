require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get accounts_path
    assert_redirected_to new_sessions_url

    sign_in_with users(:test), password: "correct_password"
    get accounts_path
    assert_response :success
  end

  test "should PATCH update" do
    new_email = "test-update-#{SecureRandom.hex 4}@example.com"

    patch accounts_url, params: { user: { email: new_email } }
    assert_redirected_to new_sessions_url

    user = users(:test)
    sign_in_with user, password: "correct_password"
    patch accounts_url, params: { user: { email: new_email } }
    assert_response :success

    user.reload
    assert_equal new_email, user.email
  end

  test "should PATCH change_password" do
    patch change_password_accounts_url, params: { user: { password: "new-password", password_confirmation: "new-password", password_challenge: "correct_password" } }
    assert_redirected_to new_sessions_url

    user = users(:test)
    sign_in_with user, password: "correct_password"
    patch change_password_accounts_url, params: { user: { password: "new-password", password_confirmation: "new-password", password_challenge: "correct_password" } }
    assert_response :success

    user.reload
    assert user.authenticate("new-password")
  end
end
