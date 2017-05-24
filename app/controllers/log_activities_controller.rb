class LogActivitiesController < EmployeeController
  before_action :set_log_activity, only: [:show, :edit, :update, :destroy]

  # GET /log_activities
  # GET /log_activities.json
  def index
    @log_activities = LogActivity.includes(:user).all.order("created_at DESC")
  end

  # GET /log_activities/1
  # GET /log_activities/1.json
  def show
  end

  # GET /log_activities/new
  def new
    @log_activity = LogActivity.new
  end

  # GET /log_activities/1/edit
  def edit
  end

  # POST /log_activities
  # POST /log_activities.json
  def create
    @log_activity = LogActivity.new(log_activity_params)

    respond_to do |format|
      if @log_activity.save
        format.html { redirect_to @log_activity, success: 'Log activity was successfully created.' }
        format.json { render :show, status: :created, location: @log_activity }
      else
        format.html { render :new }
        format.json { render json: @log_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /log_activities/1
  # PATCH/PUT /log_activities/1.json
  def update
    respond_to do |format|
      if @log_activity.update(log_activity_params)
        format.html { redirect_to @log_activity, success: 'Log activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @log_activity }
      else
        format.html { render :edit }
        format.json { render json: @log_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /log_activities/1
  # DELETE /log_activities/1.json
  def destroy
    @log_activity.destroy
    respond_to do |format|
      format.html { redirect_to log_activities_url, success: 'Log activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_log_activity
      @log_activity = LogActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def log_activity_params
      params.fetch(:log_activity, {})
    end
end
