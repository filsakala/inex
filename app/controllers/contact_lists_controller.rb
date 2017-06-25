class ContactListsController < InexMemberController
  before_action :set_contact_list, only: [:add, :add_put, :remove, :show, :edit, :update, :destroy]
  before_action :set_panel_variables, only: [:add, :index, :organizations, :events,
                                             :events_second, :events_third, :show, :new, :edit]


  # GET - add contact to contactlist
  def add
    @contacts = Contact.includes(:contact_lists)
  end

  # PUT - add contact to contactlist
  def add_put
    @contact_list.contact_in_lists.destroy_all
    if !params[:contact_ids].blank?
      params[:contact_ids].each do |contact_id|
        ContactInList.create(contact_list: @contact_list, contact_id: contact_id)
      end
    end
    redirect_to @contact_list, success: t(:contacts_were_added_to_contact_list)
  end

  # DELETE - contact from contact list
  def remove
    @contact_list.contact_in_lists.where(contact_id: params[:contact_id]).take.destroy
    redirect_to @contact_list, success: "Kontakt  #{define_notice('m', :destroy)}"
  end

  # GET /contact_lists
  # GET /contact_lists.json
  def index
    @contacts = Contact.all
    @mails    = @contacts.where('`mail` > \'\'').pluck(:mail).uniq.join(', ') # get non-blank mail contacts
    @mails    = t(:empty) if @mails.blank?
  end

  # GET
  def organizations
    @contacts     = Contact.joins(:organization)
    @mails        = @contacts.where('`mail` > \'\'').pluck(:mail).uniq.join(', ') # get non-blank mail contacts
    @mails        = t(:empty) if @mails.blank?
    @contact_list = ContactList.new(id: 0)
  end

  # GET
  def events
  end

  # GET/POST
  def events_second
    @years     ||= params[:year] || Date.today.year.downto(1993).to_a
    @events    = []
    from_field = Event.arel_table[:from]
    to_field   = Event.arel_table[:to]
    @years.each do |year|
      @events += Event.where(from_field.gteq(Date.parse("01-01-#{year}")).and(from_field.lteq(Date.parse("31-12-#{year}")))).order("`from` desc")
      @events += Event.where(to_field.gteq(Date.parse("01-01-#{year}")).and(to_field.lteq(Date.parse("31-12-#{year}")))).order("`from` desc")
    end
    @events = @events.uniq
    @events = @events.collect {
      |e|
      e.id    = e.id
      e.title = "#{e.title} (#{e.from_to})"
      e
    }

    if params[:commit] == "Na krok 3"
      redirect_to events_third_contact_lists_path(params[:events])
    end
  end

  # GET
  def events_third
    @years ||= params[:years] || Date.today.year.downto(1993).to_a
    if !params[:events].blank?
      @events = Event.where(id: params[:events])
    else
      @events = Event.all
    end
    @volunteers     = User.find(@events.joins(:volunteers).joins(:event_lists).pluck('event_lists.user_id'))
    @leaders        = User.find(@events.joins(:leaders).pluck('leaders.user_id'))
    @trainers       = User.find(@events.joins(:trainers).pluck('trainers.user_id'))
    @local_partners = User.find(@events.joins(:local_partners).pluck('local_partners.user_id'))
    @all            = (@volunteers + @leaders + @local_partners + @trainers).uniq
    # add participants to events
    @events.each do |event|
      class << event # add temporary parameter
        attr_accessor :participants
      end
      ids                = event.volunteers.joins(:event_list).pluck('event_lists.user_id') + event.leaders.pluck('leaders.user_id') + event.trainers.pluck('trainers.user_id') + event.local_partners.pluck('local_partners.user_id')
      event.participants = User.find(ids)
    end
    @description = {
      years:        (@years.blank? ? "všetky" : @years.split.sort.join(', ')),
      event_titles: @events.pluck(:title).join(', '),
      all_count:    @all.count
    }
  end

  # GET /contact_lists/1
  # GET /contact_lists/1.json
  def show
    @contacts = @contact_list.contacts
    @mails    = @contacts.where('`mail` > \'\'').pluck(:mail).uniq.join(', ') # get non-blank mail contacts
    @mails    = t(:empty) if @mails.blank?
  end

  # GET /contact_lists/new
  def new
    @contact_list = ContactList.new
    @form_params  = { employee_id: (params[:contact_list] ? params[:contact_list][:employee_id] : @contact_list.employee_id) }
  end

  # GET /contact_lists/1/edit
  def edit
    @form_params = { employee_id: (params[:contact_list] ? params[:contact_list][:employee_id] : @contact_list.employee_id) }
  end

  # POST /contact_lists
  # POST /contact_lists.json
  def create
    @contact_list = ContactList.new(contact_list_params)

    respond_to do |format|
      if @contact_list.save
        format.html { redirect_to @contact_list, success: "Adresár #{define_notice('m', __method__)}" }
        format.json { render :show, status: :created, location: @contact_list }
      else
        format.html { render :new }
        format.json { render json: @contact_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contact_lists/1
  # PATCH/PUT /contact_lists/1.json
  def update
    respond_to do |format|
      if @contact_list.update(contact_list_params)
        format.html { redirect_to @contact_list, success: "Adresár #{define_notice('m', __method__)}" }
        format.json { render :show, status: :ok, location: @contact_list }
      else
        format.html { render :edit }
        format.json { render json: @contact_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_lists/1
  # DELETE /contact_lists/1.json
  def destroy
    @contact_list.destroy
    respond_to do |format|
      format.html { redirect_to contact_lists_url, success: "Adresár #{define_notice('m', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact_list
    @contact_list = ContactList.find(params[:id])
  end

  def set_panel_variables
    @contact_lists              = current_user.employee.contact_lists
    @contact_lists_others       = ContactList.includes(employee: [:user]) - current_user.employee.contact_lists
    @organization_contact_count = Contact.joins(:organization).count
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_list_params
    params.require(:contact_list).permit(:title, :contact_ids, :employee_id)
  end
end
