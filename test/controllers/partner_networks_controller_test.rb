require 'test_helper'

class PartnerNetworksControllerTest < ActionController::TestCase
  setup do
    @partner_network = partner_networks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:partner_networks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create partner_network" do
    assert_difference('PartnerNetwork.count') do
      post :create, partner_network: { description: @partner_network.description, name: @partner_network.name }
    end

    assert_redirected_to partner_network_path(assigns(:partner_network))
  end

  test "should show partner_network" do
    get :show, id: @partner_network
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @partner_network
    assert_response :success
  end

  test "should update partner_network" do
    patch :update, id: @partner_network, partner_network: { description: @partner_network.description, name: @partner_network.name }
    assert_redirected_to partner_network_path(assigns(:partner_network))
  end

  test "should destroy partner_network" do
    assert_difference('PartnerNetwork.count', -1) do
      delete :destroy, id: @partner_network
    end

    assert_redirected_to partner_networks_path
  end
end
