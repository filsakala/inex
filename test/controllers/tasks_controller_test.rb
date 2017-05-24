require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  setup do
    @task = tasks(:one)
    session[:user_id] = users(:one).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get index others" do
    get :index_others
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get repeatable" do
    get :repeatable
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { title: @task.title }
    end

    assert_redirected_to tasks_path
  end

  test "should get edit" do
    get :edit, id: @task
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { title: @task.title }
    assert_redirected_to tasks_path
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task
    end

    assert_redirected_to tasks_path
  end
end
