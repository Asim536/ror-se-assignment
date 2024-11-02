require "test_helper"

class BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
    @blog = blogs(:one)
  end

  test "should get index" do
    get blogs_url
    assert_response :success
  end

  test "should get new" do
    get new_blog_url
    assert_response :success
  end

  test "should create blog" do
    assert_difference("Blog.count") do
      post blogs_url, params: { blog: { body: @blog.body, title: @blog.title, user_id: @user.id } }
    end

    assert_redirected_to blog_url(Blog.last)
  end

  test "should show blog" do
    get blog_url(@blog)
    assert_response :success
  end

  test "should get edit" do
    get edit_blog_url(@blog)
    assert_response :success
  end

  test "should update blog" do
    patch blog_url(@blog), params: { blog: { body: @blog.body, title: @blog.title, user_id: @user.id } }
    assert_redirected_to blog_url(@blog)
  end

  test "should destroy blog" do
    assert_difference("Blog.count", -1) do
      delete blog_url(@blog)
    end

    assert_redirected_to blogs_url
  end

  test "should import blogs" do
    assert_difference('Blog.count', 2) do
      post import_blogs_url, params: { attachment: fixture_file_upload('blogs.csv', 'text/csv') }
    end

    assert_redirected_to blogs_path
    follow_redirect!
    assert_select "h1", "Blogs"
    assert_select "td", "First Blog"
  end
end
