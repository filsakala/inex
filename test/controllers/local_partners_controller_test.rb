require 'test_helper'

class LocalPartnersControllerTest < ActionController::TestCase
  setup do
    @local_partner = local_partners(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:local_partners)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create local_partner" do
    assert_difference('LocalPartner.count') do
      post :create, local_partner: {  }
    end

    assert_redirected_to local_partner_path(assigns(:local_partner))
  end

  test "should show local_partner" do
    get :show, id: @local_partner
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @local_partner
    assert_response :success
  end

  test "should update local_partner" do
    patch :update, id: @local_partner, local_partner: {  }
    assert_redirected_to local_partner_path(assigns(:local_partner))
  end

  test "should destroy local_partner" do
    assert_difference('LocalPartner.count', -1) do
      delete :destroy, id: @local_partner
    end

    assert_redirected_to local_partners_path
  end
end
