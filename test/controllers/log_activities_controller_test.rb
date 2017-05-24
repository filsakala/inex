require 'test_helper'

class LogActivitiesControllerTest < ActionController::TestCase
  setup do
    @log_activity = log_activities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:log_activities)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create log_activity" do
    assert_difference('LogActivity.count') do
      post :create, log_activity: {  }
    end

    assert_redirected_to log_activity_path(assigns(:log_activity))
  end

  test "should show log_activity" do
    get :show, id: @log_activity
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @log_activity
    assert_response :success
  end

  test "should update log_activity" do
    patch :update, id: @log_activity, log_activity: {  }
    assert_redirected_to log_activity_path(assigns(:log_activity))
  end

  test "should destroy log_activity" do
    assert_difference('LogActivity.count', -1) do
      delete :destroy, id: @log_activity
    end

    assert_redirected_to log_activities_path
  end
end
