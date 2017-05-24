require 'test_helper'

class ImportWorkcampsControllerTest < ActionController::TestCase
  setup do
    @import_workcamp = import_workcamps(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:import_workcamps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create import_workcamp" do
    assert_difference('ImportWorkcamp.count') do
      post :create, import_workcamp: {  }
    end

    assert_redirected_to import_workcamp_path(assigns(:import_workcamp))
  end

  test "should show import_workcamp" do
    get :show, id: @import_workcamp
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @import_workcamp
    assert_response :success
  end

  test "should update import_workcamp" do
    patch :update, id: @import_workcamp, import_workcamp: {  }
    assert_redirected_to import_workcamp_path(assigns(:import_workcamp))
  end

  test "should destroy import_workcamp" do
    assert_difference('ImportWorkcamp.count', -1) do
      delete :destroy, id: @import_workcamp
    end

    assert_redirected_to import_workcamps_path
  end
end
