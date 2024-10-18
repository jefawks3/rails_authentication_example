require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should GET new" do
    get new_registrations_url
    assert_response :success

    sign_in_with users(:test), password: "correct_password"
    get new_registrations_url
    assert_redirected_to dashboards_url
  end

  test "should POST create" do
    post registrations_url
    assert_response :bad_request

    post registrations_url, params: { user: { email: "test-#{SecureRandom.hex 4}@example.com", password: "password", password_confirmation: "password" } }
    assert_redirected_to dashboards_url

    assert_not_nil session[:user_id]

    sign_in_with users(:test), password: "correct_password"
    post registrations_url
    assert_redirected_to dashboards_url
  end
end
