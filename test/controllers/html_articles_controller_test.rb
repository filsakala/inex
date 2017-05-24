require 'test_helper'

class HtmlArticlesControllerTest < ActionController::TestCase
  setup do
    @html_article = html_articles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:html_articles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create html_article" do
    assert_difference('HtmlArticle.count') do
      post :create, html_article: { category: @html_article.category, content: @html_article.content }
    end

    assert_redirected_to html_article_path(assigns(:html_article))
  end

  test "should show html_article" do
    get :show, id: @html_article
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @html_article
    assert_response :success
  end

  test "should update html_article" do
    patch :update, id: @html_article, html_article: { category: @html_article.category, content: @html_article.content }
    assert_redirected_to html_article_path(assigns(:html_article))
  end

  test "should destroy html_article" do
    assert_difference('HtmlArticle.count', -1) do
      delete :destroy, id: @html_article
    end

    assert_redirected_to html_articles_path
  end
end
