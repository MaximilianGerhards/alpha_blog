require "test_helper"

class CreateArticleTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create(username: "Max Mustermann", email: "max.mustermann@example.com", password: "Password")
  end

  test "should create article when logged in and article valid" do
    sign_in_as(@user)
    get new_article_path
    assert_response :success
    assert_difference "Article.count", 1 do
      post articles_path, params: { article: { title: "new article", description: "test article description" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "new article", response.body
  end

  test "should not create article when article name invalid" do
    sign_in_as(@user)
    get new_article_path
    assert_response :success
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: " ", description: "test article description" } }
    end
    assert_match "error", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

  test "should not create article when article description invalid" do
    sign_in_as(@user)
    get new_article_path
    assert_response :success
    assert_no_difference "Article.count" do
      post articles_path, params: { article: { title: "new article", description: "too short" } }
    end
    assert_match "error", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end

  test "should not create article when not logged in" do
    get new_article_path
    assert_redirected_to login_url
    assert_no_difference("Article.count") do
      post articles_url, params: { article: { title: "new article", description: "test article description" } }
    end

    assert_redirected_to login_url
  end
end
