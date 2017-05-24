require 'test_helper'

class ParticipationFeesControllerTest < ActionController::TestCase
  setup do
    @participation_fee = participation_fees(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:participation_fees)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create participation_fee" do
    assert_difference('ParticipationFee.count') do
      post :create, participation_fee: {  }
    end

    assert_redirected_to participation_fee_path(assigns(:participation_fee))
  end

  test "should show participation_fee" do
    get :show, id: @participation_fee
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @participation_fee
    assert_response :success
  end

  test "should update participation_fee" do
    patch :update, id: @participation_fee, participation_fee: {  }
    assert_redirected_to participation_fee_path(assigns(:participation_fee))
  end

  test "should destroy participation_fee" do
    assert_difference('ParticipationFee.count', -1) do
      delete :destroy, id: @participation_fee
    end

    assert_redirected_to participation_fees_path
  end
end
