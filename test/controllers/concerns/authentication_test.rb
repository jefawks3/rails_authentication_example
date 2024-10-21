# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class AuthenticationTest < ActiveSupport::TestCase
  attr_reader :subject

  setup do
    @subject = AuthenticationTest.new
  end

  test "has helper methods" do
    assert subject._helper_methods.include?(:current_user)
    assert subject._helper_methods.include?(:user_signed_in?)
  end

  test "uses the user id from the session" do
    assert_nil subject.current_user
    assert_not subject.user_signed_in?

    subject.session[:user_id] = users(:test).id

    assert users(:test), subject.current_user
    assert subject.user_signed_in?
  end

  test "signs the user in and resets the session" do
    assert_nil subject.current_user

    user = users(:test)
    mock = Minitest::Mock.new
    mock.expect :call, nil

    subject.stub :reset_session, mock do
      subject.sign_in user
    end

    assert_equal user, subject.current_user
    assert_equal user.id, subject.session[:user_id]
    assert subject.user_signed_in?
    assert_mock mock
  end

  test "signs the user out and resets the session" do
    subject.session[:user_id] = users(:test).id

    assert subject.user_signed_in?

    mock = Minitest::Mock.new
    mock.expect :call, nil

    subject.stub :reset_session, mock do
      subject.sign_out
    end

    assert_nil subject.current_user
    assert_not subject.session.key?(:user_id)
    assert_mock mock
  end

  test "requires user authentication" do
    mock = Minitest::Mock.new
    mock.expect :call, nil, [Rails.application.routes.url_helpers.new_sessions_path]

    subject.stub :redirect_to, mock do
      subject.user_authenticated!
    end

    assert_mock mock
    assert_equal "/test/authentication?key=value", subject.session[:return_to_after_authentication]

    subject.sign_in users(:test)

    assert_no_error_reported { subject.user_authenticated! }
  end

  test "requires an anonymous user" do
    mock = Minitest::Mock.new
    mock.expect :call, nil, [Rails.application.routes.url_helpers.dashboards_path]

    assert_no_error_reported { subject.user_not_authenticated! }

    subject.sign_in users(:test)

    subject.stub :redirect_to, mock do
      subject.user_not_authenticated!
    end

    assert_mock mock
  end

  test "returns and deletes the location to return to" do
    assert_not subject.session.key?(:return_to_after_authentication)
    assert_nil subject.return_to_after_authentication_path

    subject.session[:return_to_after_authentication] = "test/location"
    assert_equal "test/location", subject.return_to_after_authentication_path
    assert_not subject.session.key?(:return_to_after_authentication)
  end

  class AuthenticationTest
    include AbstractController::Helpers
    include Authentication
    include Rails.application.routes.url_helpers

    def session
      @session ||= {}
    end

    def reset_session
      @session = {}
    end

    def request
      @request ||= ActionDispatch::TestRequest.create(Rack::MockRequest.env_for("http://www.example.com/test/authentication?key=value"))
    end

    def default_url_options
      Rails.application.default_url_options
    end

    def redirect_to(*); end
  end
end
