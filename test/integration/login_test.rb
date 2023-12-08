require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
    def setup
        @user = User.create(username: "Test user", email: "test@example.com", password: "Password")
    end

    test "should allow user to login" do
        get login_path
        assert_response :success
        post login_path, params: { session: { email: @user.email, password: "Password" } }
        @current_user ||= User.find(session[:user_id]) unless session[:user_id].nil?
        assert !!@current_user
        assert_response :redirect
        follow_redirect!
        assert_match "Log out", response.body
        assert_match "Logged in", response.body
    end

    test "should allow logged-in user to log out" do
        sign_in_as(@user)
        get articles_path
        assert_select "a[href=?]", logout_path, text: "Log out"
        delete logout_path
        assert_response :redirect
        follow_redirect!
        assert_match "Logged out", response.body
        @current_user ||= User.find(session[:user_id]) unless session[:user_id].nil?
        assert_not !!@current_user
    end
end