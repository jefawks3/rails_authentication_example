require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should GET show" do
    get dashboards_url
    assert_redirected_to new_sessions_url

    sign_in_with users(:test), password: "correct_password"
    get dashboards_url
    assert_response :success
  end
end
