require 'test_helper'

class HomepageCardsControllerTest < ActionController::TestCase
  setup do
    @homepage_card = homepage_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:homepage_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create homepage_card" do
    assert_difference('HomepageCard.count') do
      post :create, homepage_card: { priority: @homepage_card.priority, title: @homepage_card.title, url: @homepage_card.url }
    end

    assert_redirected_to homepage_card_path(assigns(:homepage_card))
  end

  test "should show homepage_card" do
    get :show, id: @homepage_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @homepage_card
    assert_response :success
  end

  test "should update homepage_card" do
    patch :update, id: @homepage_card, homepage_card: { priority: @homepage_card.priority, title: @homepage_card.title, url: @homepage_card.url }
    assert_redirected_to homepage_card_path(assigns(:homepage_card))
  end

  test "should destroy homepage_card" do
    assert_difference('HomepageCard.count', -1) do
      delete :destroy, id: @homepage_card
    end

    assert_redirected_to homepage_cards_path
  end
end
