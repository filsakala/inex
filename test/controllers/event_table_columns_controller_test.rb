require 'test_helper'

class EventTableColumnsControllerTest < ActionController::TestCase
  setup do
    @event_table_column = event_table_columns(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_table_columns)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_table_column" do
    assert_difference('EventTableColumn.count') do
      post :create, event_table_column: {  }
    end

    assert_redirected_to event_table_column_path(assigns(:event_table_column))
  end

  test "should show event_table_column" do
    get :show, id: @event_table_column
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_table_column
    assert_response :success
  end

  test "should update event_table_column" do
    patch :update, id: @event_table_column, event_table_column: {  }
    assert_redirected_to event_table_column_path(assigns(:event_table_column))
  end

  test "should destroy event_table_column" do
    assert_difference('EventTableColumn.count', -1) do
      delete :destroy, id: @event_table_column
    end

    assert_redirected_to event_table_columns_path
  end
end
