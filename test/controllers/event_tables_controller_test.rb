require 'test_helper'

class EventTablesControllerTest < ActionController::TestCase
  setup do
    @event_table = event_tables(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_tables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_table" do
    assert_difference('EventTable.count') do
      post :create, event_table: {  }
    end

    assert_redirected_to event_table_path(assigns(:event_table))
  end

  test "should show event_table" do
    get :show, id: @event_table
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_table
    assert_response :success
  end

  test "should update event_table" do
    patch :update, id: @event_table, event_table: {  }
    assert_redirected_to event_table_path(assigns(:event_table))
  end

  test "should destroy event_table" do
    assert_difference('EventTable.count', -1) do
      delete :destroy, id: @event_table
    end

    assert_redirected_to event_tables_path
  end
end
