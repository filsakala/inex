require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase
  setup do
    @employee = employees(:one)
    session[:user_id] = users(:one).id
  end

  test "should get edit" do
    get :edit, id: @employee
    assert_response :success
  end

  test "should update employee" do
    patch :update, id: @employee, employee: { department: @employee.department, work_mail: @employee.work_mail, work_phone: @employee.work_phone }
    assert_redirected_to users_path
  end
end
