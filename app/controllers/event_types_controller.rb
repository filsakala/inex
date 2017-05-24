class EventTypesController < ApplicationController
  before_action :set_event_type, only: [:search, :bags_search, :bags, :show, :edit, :application_conditions, :update, :destroy]
  layout "page_part", only: [:application_conditions]

  # GET /event_types
  # GET /event_types.json
  def index
    @event_types = EventType.all
    @without_type = Event.where(event_type_id: nil)
    @super_event_types = SuperEventType.all
    @event_types_without_super_type = EventType.where(super_event_type_id: nil)
  end

  # GET /event_types/1
  # GET /event_types/1.json
  def show
    per_page = params[:per_page]
    per_page ||= 10
    page = params[:page] || 1
    events = do_search(@event_type, params[:query])
    if events.count < (page.to_i - 1) * (per_page.to_i) + 1
      page = 1
    end
    @events = events.order(from: :desc).paginate(page: page, per_page: per_page)
  end

  def search
    events = do_search(@event_type, params[:q])
    res = events.collect { |u|
      { "title": "#{u.title}", "url": event_type_event_path(@event_type, u),
        "description": u.from_to }
    }
    render json: {
      "results": res,
      "action": {
        "url": event_type_path(@event_type, query: params[:q], page: params[:page], per_page: params[:per_page]),
        "text": "Obnoviť tabuľku (#{res.size} výsledkov)"
      }
    }
  end

  def do_search(event_type, query)
    t = Event.arel_table
    if !query.blank?
      q = query.split(' ').join('|')
      event_type.events.where("`title` REGEXP ? OR `from` REGEXP ? OR `to` REGEXP ? OR `country` REGEXP ? OR `code` REGEXP ? OR `code_alliance` REGEXP ? ", q, q, q, q, q, q)
    else
      event_type.events
    end
  end

  # GET
  def bags
    per_page = params[:per_page]
    per_page ||= 10
    page = params[:page] || 1
    bags = do_bags_search(params[:query])
    if bags.count < (page.to_i - 1) * (per_page.to_i) + 1
      page = 1
    end
    @bags = bags.paginate(page: page, per_page: per_page)
  end

  def bags_search
    events = do_bags_search(params[:q])
    res = events.collect { |u|
      { "title": "#{u.name} #{u.surname}", "url": bags_event_type_path(@event_type, query: params[:q], page: params[:page], per_page: params[:per_page]),
        "description": u.state }
    }
    render json: {
      "results": res,
      "action": {
        "url": bags_event_type_path(@event_type, query: params[:q], page: params[:page], per_page: params[:per_page]),
        "text": "Obnoviť tabuľku (#{res.size} výsledkov)"
      }
    }
  end

  def do_bags_search(query)
    t = EventList.arel_table
    if !query.blank?
      q = query.split(' ').join('|')
      EventList.where.not(state: 'opened').includes(:events, :user, :participation_fees).where(events: { event_type_id: @event_type.id }).uniq.where("`users`.`name` REGEXP ? OR `users`.`surname` REGEXP ? OR `event_lists`.`state` REGEXP ? ", q, q, q).order(:state).order("users.surname")
    else
      EventList.where.not(state: 'opened').includes(:events, :user, :participation_fees).where(events: { event_type_id: @event_type.id }).uniq.order(:state).order("users.surname")
    end
  end

  # GET /event_types/new
  def new
    @event_type = EventType.new
    @supertypes = SuperEventType.all
    @employees = Employee.joins(:user).select(:id, :name, :nickname, :user_id)
  end

  # GET /event_types/1/edit
  def edit
    @supertypes = SuperEventType.all
    @employees = Employee.joins(:user).select(:id, :name, :nickname, :user_id)
  end

  # GET
  def application_conditions
  end

  # POST /event_types
  # POST /event_types.json
  def create
    @event_type = EventType.new(event_type_params)

    respond_to do |format|
      if @event_type.save
        format.html { redirect_to @event_type, success: 'Event type was successfully created.' }
        format.json { render :show, status: :created, location: @event_type }
      else
        format.html { render :new }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /event_types/1
  # PATCH/PUT /event_types/1.json
  def update
    respond_to do |format|
      if @event_type.update(event_type_params)
        format.html { redirect_to @event_type, success: 'Event type was successfully updated.' }
        format.json { render :show, status: :ok, location: @event_type }
      else
        format.html { render :edit }
        format.json { render json: @event_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /event_types/1
  # DELETE /event_types/1.json
  def destroy
    @event_type.destroy
    respond_to do |format|
      format.html { redirect_to event_types_url, success: 'Event type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event_type
    @event_type = EventType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_type_params
    params.require(:event_type).permit(:title, :fee_member_first, :fee_non_member_first,
                                       :fee_member_other, :fee_non_member_other,
                                       :fee_description, :application_conditions_html,
                                       :application_conditions_agreement_html,
                                       :application_info_html, :can_send_registration_mail,
                                       :super_event_type_id, :employee_id)
  end
end
