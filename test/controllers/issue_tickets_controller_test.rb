require 'test_helper'

class IssueTicketsControllerTest < ActionController::TestCase
  setup do
    @issue_ticket = issue_tickets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:issue_tickets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create issue_ticket" do
    assert_difference('IssueTicket.count') do
      post :create, issue_ticket: { description: @issue_ticket.description, priority: @issue_ticket.priority, user: @issue_ticket.user }
    end

    assert_redirected_to issue_ticket_path(assigns(:issue_ticket))
  end

  test "should show issue_ticket" do
    get :show, id: @issue_ticket
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @issue_ticket
    assert_response :success
  end

  test "should update issue_ticket" do
    patch :update, id: @issue_ticket, issue_ticket: { description: @issue_ticket.description, priority: @issue_ticket.priority, user: @issue_ticket.user }
    assert_redirected_to issue_ticket_path(assigns(:issue_ticket))
  end

  test "should destroy issue_ticket" do
    assert_difference('IssueTicket.count', -1) do
      delete :destroy, id: @issue_ticket
    end

    assert_redirected_to issue_tickets_path
  end
end
