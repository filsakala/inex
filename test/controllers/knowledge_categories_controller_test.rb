require 'test_helper'

class KnowledgeCategoriesControllerTest < ActionController::TestCase
  setup do
    @knowledge_category = knowledge_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:knowledge_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create knowledge_category" do
    assert_difference('KnowledgeCategory.count') do
      post :create, knowledge_category: {  }
    end

    assert_redirected_to knowledge_category_path(assigns(:knowledge_category))
  end

  test "should show knowledge_category" do
    get :show, id: @knowledge_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @knowledge_category
    assert_response :success
  end

  test "should update knowledge_category" do
    patch :update, id: @knowledge_category, knowledge_category: {  }
    assert_redirected_to knowledge_category_path(assigns(:knowledge_category))
  end

  test "should destroy knowledge_category" do
    assert_difference('KnowledgeCategory.count', -1) do
      delete :destroy, id: @knowledge_category
    end

    assert_redirected_to knowledge_categories_path
  end
end
