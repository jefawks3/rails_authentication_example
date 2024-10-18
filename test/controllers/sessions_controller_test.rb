require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should GET new" do
    get new_sessions_url
    assert_response :success

    sign_in_with users(:test), password: "correct_password"
    get new_sessions_url
    assert_redirected_to dashboards_url
  end

  test "should POST create" do
    post sessions_url
    assert_response :bad_request

    post sessions_url, params: { user: { email: users(:test).email, password: "invalid" } }
    assert_response :success

    post sessions_url, params: { user: { email: users(:test).email, password: "correct_password" } }
    assert_redirected_to dashboards_url

    assert_not_nil session[:user_id]
  end

  test "should DELETE destroy" do
    delete sessions_url
    assert_redirected_to new_sessions_url
    assert_nil session[:user_id]

    sign_in_with users(:test), password: "correct_password"
    delete sessions_url
    assert_redirected_to new_sessions_url
    assert_nil session[:user_id]
  end
end
