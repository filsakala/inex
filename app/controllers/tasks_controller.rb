class TasksController < EmployeeController
  before_action :set_task, only: [:generate_ical, :highlight, :add_to_my_list, :edit, :update, :destroy]
  before_action :employee_whithout_eds_check, only: [:index_others, :repeatable]

  def generate_ical
    cal = Icalendar::Calendar.new
    filename = "INEX task.ics"

    cal.event do |e|
      e.dtstart     = Icalendar::Values::DateTime.new(@task.deadline)
      e.dtend       = Icalendar::Values::DateTime.new(@task.deadline)
      e.summary     = @task.title
      e.description = @task.description
      e.url         = "http://inex.sk"
    end

    send_data cal.to_ical, type: 'text/calendar', disposition: 'attachment', filename: filename
  end

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = current_user.employee.tasks.includes(:task_lists).order('is_highlighted DESC').order('deadline')
  end

  def index_others
    emp_tasks = current_user.employee.tasks
    @tasks = Task.where(is_repeatable: false).order('is_highlighted DESC').order('deadline') - emp_tasks
  end

  def repeatable
    @tasks = Task.where(is_repeatable: true).order('is_highlighted DESC').order('deadline')
  end

  def highlight
    @task.update(is_highlighted: !@task.is_highlighted)
    redirect_to :back, success: "#{t(:task_highlighting)} #{define_notice('s', :update)}"
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @members = User.where(role: ['employee', 'eds', 'evs'])
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST
  def add_to_my_list
    task = @task.dup # duplicate tasks attributes
    task.is_repeatable = false
    task.employee = current_user.employee
    if task.save
      @task.task_lists.each do |tl|
        ctl = tl.dup
        ctl.task = task
        unless ctl.save
          task.destroy
          break
        end
      end
    end
    if task
      redirect_to repeatable_tasks_path, success: t(:task_was_successfully_added_to_my_tasks)
    else
      redirect_to repeatable_tasks_path, error: t(:task_was_not_added_to_my_tasks)
    end
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)
    if @task.is_repeatable # If the task is repeatable, save another copy
      repeatable = Task.new(task_params)
      repeatable.employee = nil
      repeatable.save
    end

    respond_to do |format|
      if @task.valid?
        if !params[:user_ids].blank?
          users = User.find(params[:user_ids])
          Task.create_this_task_for_users(users, task_params)
        else
          @task.is_repeatable = false
          @task.employee = current_user.employee
          @task.save
        end
        format.html { redirect_to tasks_path, success: "#{t :task} #{define_notice('ž', __method__)}" }
      else
        @members = User.where(role: 'employee').where(state: 'active')
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      task_params_updated = task_params
      # Ak updatujes task, nebol repeatable a ma byt, vytvor samostatne repeatable
      if !@task.is_repeatable && task_params_updated[:is_repeatable] == "1"
        task_lists_attributes = task_params_updated[:task_lists_attributes]
        task_params_updated[:task_lists_attributes] = []
        @repeatable = Task.new(task_params_updated)
        @repeatable.employee = nil
        @repeatable.save

        @task.task_lists.each do |tl|
          newtl = tl.attributes
          newtl[:id] = nil
          newtl[:task_id] = @repeatable.id
          @repeatable.task_lists.create(newtl)
        end

        task_params_updated[:task_lists_attributes] = task_lists_attributes
        task_params_updated[:is_repeatable] = "0"
      end
      if @task.is_repeatable
        path = repeatable_tasks_path
      elsif @task.employee == Employee.find_by_user_id(session[:user_id])
        path = tasks_path
      else
        path = index_others_tasks_path
      end
      if @task.update(task_params_updated)
        format.html { redirect_to path, success: "#{t :task} #{define_notice('ž', __method__)}" }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to :back, success: "#{t :task} #{define_notice('ž', __method__)}" }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def employee_whithout_eds_check
    if !current_user || (current_user && !current_user.is_employee?)
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def task_params
    params.require(:task).permit(:title, :description, :user_ids, :is_repeatable, :is_highlighted, :deadline, task_lists_attributes: [:title, :state, :id, :_destroy],
                                 task_list_attributes: [:title, :state])
  end
end
