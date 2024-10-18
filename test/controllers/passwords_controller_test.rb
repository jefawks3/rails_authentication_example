require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "should GET new" do
    get new_passwords_path
    assert_response :success

    sign_in_with users(:test), password: "correct_password"
    get new_passwords_path
    assert_redirected_to dashboards_path
  end

  test "should POST create" do
    post passwords_path, params: { email: "test-#{SecureRandom.hex 4}@example.com" }
    assert_response :success

    assert_emails 1 do
      post passwords_path, params: { email: users(:test).email }
      assert_response :success
    end
  end

  test "should GET edit" do
    get edit_passwords_url
    assert_redirected_to new_passwords_path

    get edit_passwords_url(token: "invalid")
    assert_redirected_to new_passwords_path

    token = users(:test).generate_token_for(:password_reset)
    get edit_passwords_url(token: token)
    assert_response :success

    sign_in_with users(:test), password: "correct_password"
    get edit_passwords_url
    assert_redirected_to dashboards_path
  end

  test "should PATCH update" do
    patch passwords_url
    assert_redirected_to new_passwords_path

    patch passwords_url, params: { token: "invalid", user: { password: "password", password_confirmation: "password" } }
    assert_redirected_to new_passwords_path

    user = users(:test)
    patch passwords_url, params: { token: user.generate_token_for(:password_reset), user: { password: "password", password_confirmation: "password" } }
    assert_redirected_to new_sessions_url

    user.reload
    assert user.authenticate("password")

    sign_in_with users(:test), password: "password"
    patch passwords_url, params: { token: "invalid", user: { password: "password", password_confirmation: "password" } }
    assert_redirected_to dashboards_path
  end
end
