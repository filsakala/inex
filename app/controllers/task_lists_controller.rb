class TaskListsController < InexMemberController
  before_action :set_task_list, only: [:update_state]

  # PATCH/PUT
  def update_state
    @task_list.state = if @task_list.state == 'nedokončená' then
                         'dokončená'
                       else
                         'nedokončená'
                       end
    @task_list.save
    render :nothing => true, :status => 200, :content_type => 'text/html'
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
