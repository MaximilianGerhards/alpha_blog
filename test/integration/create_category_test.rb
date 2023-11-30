require "test_helper"

class CreateCategoryTest < ActionDispatch::IntegrationTest

  def setup
    @admin = User.create(username: "Max Mustermann", email: "max.mustermann@example.com", password: "Password", admin: true)
    sign_in_as(@admin)
  end

  test "get new category form and create category" do
    get new_category_path
    assert_response :success
    assert_difference "Category.count", 1 do
      post categories_path, params: { category: { name: "Outdoor" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_match "Outdoor", response.body
  end

  test "get new category form and reject invalid category submission" do
    get new_category_path
    assert_response :success
    assert_no_difference "Category.count" do
      post categories_path, params: { category: { name: " " } }
    end
    assert_match "error", response.body
    assert_select 'div.alert'
    assert_select 'h4.alert-heading'
  end
end
