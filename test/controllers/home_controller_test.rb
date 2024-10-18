require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should GET show" do
    get root_path
    assert_response :success

    sign_in_with users(:test), password: "correct_password"
    get root_path
    assert_response :success
  end
end
