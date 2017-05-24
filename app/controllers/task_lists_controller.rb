class TaskListsController < EmployeeController
  before_action :set_task_list, only: [:update_state]

  # PATCH/PUT
  def update_state
    if @task_list.state == 'nedokončená'
      @task_list.state = 'dokončená'
    else
      @task_list.state = 'nedokončená'
    end
    @task_list.save
    render :nothing => true, :status => 200, :content_type => 'text/html'
    # respond_to do |format|
    #   if @task_list.save
    #     format.html { redirect_to :back, notice: "Zoznam úloh  #{define_notice('m', :update)}" }
    #     format.json { render :show, status: :ok, location: @task_list }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @task_list.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task_list
    @task_list = TaskList.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_list_params
    params.require(:task_list).permit(:title)
  end
end
