class EventCategoriesController < InexMemberController
  before_action :set_event_category, only: [:edit, :update, :destroy]

  # GET /event_categories
  def index
    @event_categories = EventCategory.includes(:event_category_scis, :event_category_alliances)
  end

  # GET /event_categories/new
  def new
    @event_category = EventCategory.new
  end

  # POST /event_categories
  def create
    @event_category = EventCategory.new(event_category_params)
    respond_to do |format|
      if @event_category.save
        format.html { redirect_to event_categories_path, success: "#{t :event_category} #{define_notice('m', __method__)}" }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /event_categories/1
  def update
    respond_to do |format|
      if @event_category.update(event_category_params)
        format.html { redirect_to event_categories_path, success: "#{t :event_category} #{define_notice('m', __method__)}" }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /event_categories/1
  def destroy
    @event_category.destroy
    respond_to do |format|
      format.html { redirect_to event_categories_url, success: "#{t :event_category} #{define_notice('m', __method__)}" }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event_category
    @event_category = EventCategory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_category_params
    params.require(:event_category).permit(:name, :abbr,
                                           event_category_scis_attributes: [:name, :id, :_destroy],
                                           event_category_alliances_attributes: [:name, :id, :_destroy]
    )
  end
end
