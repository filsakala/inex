class EventTablesController < EmployeeController
  before_action :set_event_table, only: [:add_row, :remove_row, :show, :edit, :update, :destroy]
  before_action :set_event_type, only: [:index, :new, :add_row, :remove_row, :show, :edit, :update, :destroy]

  def add_row
    @event_table.event_table_rows.create(is_header: false)
    @event_table.build_table # fill blank cells
    redirect_to [@event_table.event_type, @event_table], success: t(:row_was_added)
  end

  def remove_row
    EventTableRow.find(params[:row_id]).destroy
    redirect_to [@event_table.event_type, @event_table], success: t(:row_was_deleted)
  end

  # PUT
  def sort
    params[:order].each do |key, value|
      EventTableColumn.find(value[:id]).update_attribute(:priority, value[:position])
    end
    render :nothing => true
  end

  # GET /event_tables
  # GET /event_tables.json
  def index
    @event_tables = @event_type.event_tables
    @users = User.all
    if @event_tables.any?
      @first = @event_tables.first
      @other = @event_tables.where.not(id: @first.id)
    else
      @other = []
    end
  end

  # GET /event_tables/1
  # GET /event_tables/1.json
  def show
    @event_tables = @event_type.event_tables
    @users = User.all
  end

  # GET /event_tables/new
  def new
    @event_table = EventTable.new
    @headers = []
  end

  # GET /event_tables/1/edit
  def edit
    @header_row = @event_table.event_table_rows.where(is_header: true).take
    @header_row = @event_table.event_table_rows.create(is_header: true) if !@header_row
    @headers = @header_row.event_table_columns
  end

  # POST /event_tables
  # POST /event_tables.json
  def create
    @event_table = EventTable.new(event_table_params)

    respond_to do |format|
      if @event_table.save
        columns = []
        if !params["names"].blank?
          types = params[:types].blank? ? [] : params[:types]
          params['names'].each_with_index do |name, index|
            type = types[index].blank? ? "string" : types[index]
            columns << { name: name, type: type } if !name.blank?
          end
        end
        @event_table.add_to_header(columns)

        # Add 10 rows
        (0...10).each do
          @event_table.event_table_rows.create(is_header: false)
        end
        @event_table.build_table # fill blank cells
        format.html { redirect_to [@event_table.event_type, @event_table], success: "#{t :table} #{define_notice('ž', __method__)}" }
        format.json { render :show, statusy: :created, location: @event_table }
      else
        format.html { render :new }
        format.json { render json: @event_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_tables/1
  # PATCH/PUT /event_tables/1.json
  def update
    respond_to do |format|
      if @event_table.update(event_table_params)
        @headers = @event_table.event_table_rows.where(is_header: true).take.event_table_columns
        @headers.each do |header|
          if !params[header.id.to_s].blank?
            if params[header.id.to_s][0].blank?
              header.destroy
            elsif header.name != params[header.id.to_s][0] || header.ctype != params[header.id.to_s][1]
              header.ctype = params[header.id.to_s][1]
              header.name = params[header.id.to_s][0]
              header.save
            end
          else
            header.destroy
          end
        end
        # New headers
        columns = []
        if !params["names"].blank?
          types = params[:types].blank? ? [] : params[:types]
          params['names'].each_with_index do |name, index|
            type = types[index].blank? ? "string" : types[index]
            columns << { name: name, type: type } if !name.blank?
          end
        end
        @event_table.add_to_header(columns)
        @event_table.build_table # fill blank cells
        format.html { redirect_to [@event_table.event_type, @event_table], success: "#{t :table} #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :ok, location: @event_table }
      else
        format.html { render :edit }
        format.json { render json: @event_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_tables/1
  # DELETE /event_tables/1.json
  def destroy
    @event_table.destroy
    respond_to do |format|
      format.html { redirect_to event_tables_url, success: "#{t :table} #{define_notice('ž', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event_table
    @event_table = EventTable.find(params[:id])
  end

  def set_event_type
    @event_type = EventType.find(params[:event_type_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_table_params
    params.require(:event_table).permit(:name, :ctype, :event_type_id)
  end
end
