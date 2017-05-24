class EmployeeController < ApplicationController
  before_action :employee_check

  private
  def employee_check
    if !current_user.try(:is_inex_member?)
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end
end
