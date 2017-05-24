require 'test_helper'

class BlogPostsControllerTest < ActionController::TestCase
  setup do
    @blog_post = blog_posts(:one)
    session[:user_id] = users(:one).id
  end

  test "should get index" do
    get :index
  end

  test "should show categories" do
    get :categories, id: @blog_post
  end

  test "should post categories" do
    assert_difference('BlogPostCategory.count') do
      post :categories, "#{@blog_post.blog_post_category.id}": ["updated"], "new": ["new", "", ""], "commit": "Uložiť"
    end
    @blog_post.blog_post_category.reload
    assert @blog_post.blog_post_category.name == "updated"
    assert_redirected_to blog_posts_path
  end

  test "should show blog_post" do
    get :show, id: @blog_post
  end

  test "should get new" do
    assert_difference('BlogPost.count') do
      get :new
    end
    assert_redirected_to blog_posts_path
  end

  test "should destroy blog_post" do
    assert_difference('BlogPost.count', -1) do
      delete :destroy, id: @blog_post
    end

    assert_redirected_to blog_posts_path
  end

  test "should toggle is published" do
    before = @blog_post.is_published
    put :toggle_is_published, id: @blog_post
    @blog_post.reload
    assert @blog_post.is_published != before
    assert_redirected_to blog_posts_path
  end

  test "should mercury update" do
    before_title = @blog_post.title
    before_perex = @blog_post.perex
    before_text = @blog_post.text
    put :mercury_update, id: @blog_post, "content": {
      "title": {
        "type"=>"markdown",
        "value"=>"updated title"
      }, "perex": {
        "type"=>"markdown",
        "value"=>"updated perex"
      }, "text": {
        "type"=>"full",
        "value"=>"updated text"}
    }
    @blog_post.reload
    assert @blog_post.title != before_title
    assert @blog_post.perex != before_perex
    assert @blog_post.text != before_text
    assert_response :success
  end

  # :categories, :new, :destroy, :toggle_is_published, :mercury_update
  test "should not make changes categories" do
    session[:user_id] = users(:two).id # is not employee
    assert_difference('BlogPostCategory.count', 0) do
      post :categories, "#{@blog_post.blog_post_category.id}": ["updated"], "new": ["new", "", ""], "commit": "Uložiť"
    end
    assert_redirected_to root_path
  end

  test "should not make changes new" do
    session[:user_id] = users(:two).id # is not employee
    assert_difference('BlogPost.count', 0) do
      get :new
    end
    assert_redirected_to root_path
  end

  test "should not make changes destroy" do
    session[:user_id] = users(:two).id # is not employee
    assert_difference('BlogPost.count', 0) do
      delete :destroy, id: @blog_post
    end
    assert_redirected_to root_path
  end

  test "should not make changes toggle_is_published" do
    session[:user_id] = users(:two).id # is not employee
    before = @blog_post.is_published
    put :toggle_is_published, id: @blog_post
    @blog_post.reload
    assert @blog_post.is_published == before
    assert_redirected_to root_path
  end

  test "should not make changes mercury update" do
    session[:user_id] = users(:two).id # is not employee
    before_title = @blog_post.title
    before_perex = @blog_post.perex
    before_text = @blog_post.text
    put :mercury_update, id: @blog_post, "content": {
      "title": {
        "type"=>"markdown",
        "value"=>"updated title"
      }, "perex": {
        "type"=>"markdown",
        "value"=>"updated perex"
      }, "text": {
        "type"=>"full",
        "value"=>"updated text"}
    }
    @blog_post.reload
    assert @blog_post.title == before_title
    assert @blog_post.perex == before_perex
    assert @blog_post.text == before_text
    assert_redirected_to root_path
  end
end
