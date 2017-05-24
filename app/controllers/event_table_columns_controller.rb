class EventTableColumnsController < EmployeeController
  before_action :set_event_table_column, only: [:show, :edit, :update, :destroy]

  # GET /event_table_columns
  # GET /event_table_columns.json
  def index
    @event_table_columns = EventTableColumn.all
  end

  # GET /event_table_columns/1
  # GET /event_table_columns/1.json
  def show
  end

  # GET /event_table_columns/new
  def new
    @event_table_column = EventTableColumn.new
  end

  # GET /event_table_columns/1/edit
  def edit
  end

  # POST /event_table_columns
  # POST /event_table_columns.json
  def create
    @event_table_column = EventTableColumn.new(event_table_column_params)

    respond_to do |format|
      if @event_table_column.save
        format.html { redirect_to @event_table_column, success: 'Event table column was successfully created.' }
        format.json { render :show, status: :created, location: @event_table_column }
      else
        format.html { render :new }
        format.json { render json: @event_table_column.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_table_columns/1
  # PATCH/PUT /event_table_columns/1.json
  def update
    respond_to do |format|
      if @event_table_column.update(event_table_column_params)
        format.html { redirect_to @event_table_column, success: 'Event table column was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_table_column }
      else
        format.html { render :edit }
        format.json { render json: @event_table_column.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_table_columns/1
  # DELETE /event_table_columns/1.json
  def destroy
    @event_table_column.destroy
    respond_to do |format|
      format.html { redirect_to event_table_columns_url, success: 'Event table column was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event_table_column
      @event_table_column = EventTableColumn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_table_column_params
      params.require(:event_table_column).permit(:value, :color)
    end
end
