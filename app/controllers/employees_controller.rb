class EmployeesController < EmployeeController
  before_action :set_employee, only: [:edit, :update]

  def new
    @user = User.find(params[:user_id])
  end

  # GET /employees/1/edit
  def edit
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if !params[:user].blank? && !params[:user][:role].blank?
        @employee.user.role = params[:user][:role]
        @employee.user.save(validate: false)
      end
      if @employee.update(employee_params)
        format.html { redirect_to users_path, success: "#{t :employee} #{define_notice('m', __method__)}" }
      else
        format.html { render :edit }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:department, :work_mail, :work_phone)
    end
end
