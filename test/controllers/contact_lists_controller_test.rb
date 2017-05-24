require 'test_helper'

class ContactListsControllerTest < ActionController::TestCase
  setup do
    @contact_list = contact_lists(:one)
    session[:user_id] = users(:one).id
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contact_lists)
  end

  test "should get organizations" do
    get :organizations
    assert_response :success
    assert_not_nil assigns(:contact_lists)
  end

  test "should get add" do
    get :add, id: @contact_list
    assert_response :success
    assert_not_nil assigns(:contact_lists)
  end

  test "should get events" do
    get :events
    assert_response :success
    assert_not_nil assigns(:contact_lists)
  end

  test "should get events second" do
    get :events_second
    assert_response :success
    assert_not_nil assigns(:contact_lists)
  end

  test "should get events third" do
    get :events_third
    assert_response :success
    assert_not_nil assigns(:contact_lists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact_list" do
    assert_difference('ContactList.count') do
      post :create, contact_list: { title: @contact_list.title }
    end

    assert_redirected_to contact_list_path(assigns(:contact_list))
  end

  test "should show contact_list" do
    get :show, id: @contact_list
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact_list
    assert_response :success
  end

  test "should update contact_list" do
    patch :update, id: @contact_list, contact_list: { title: @contact_list.title }
    assert_redirected_to contact_list_path(assigns(:contact_list))
  end

  test "should add_put contact_list" do
    new_contacts = Contact.where.not(id: @contact_list.contacts.pluck(:id)).pluck(:id)
    count_before = @contact_list.contacts.count
    put :add_put, id: @contact_list, contact_ids: new_contacts
    @contact_list.contacts.reload
    assert @contact_list.contacts.count > count_before
    assert_redirected_to contact_list_path(assigns(:contact_list))
  end

  test "should destroy contact_list" do
    assert_difference('ContactList.count', -1) do
      delete :destroy, id: @contact_list
    end

    assert_redirected_to contact_lists_path
  end

  test "should remove from contact_list" do
    contact = @contact_list.contacts.first.id
    count_before = @contact_list.contacts.count
    delete :remove, id: @contact_list, contact_id: contact
    @contact_list.contacts.reload
    assert @contact_list.contacts.count < count_before
    assert_redirected_to @contact_list
  end
end
