class ContactsController < InexMemberController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_panel_variables, only: [:index, :show, :new, :edit]
  include Searchable
  include ContactsHelper

  def search
    if !params[:eid].blank?
      if params[:eid] != "0"
        contacts = ContactList.find(params[:eid]).contacts.includes(:organization)
      else
        contacts = Contact.joins(:organization)
      end
    else
      contacts = Contact.includes(:organization)
    end
    results = do_search(contacts, columns: [:name, :nickname, :surname, :dept, :mail, :phone], order_by: { surname: :asc })
    results = results.collect { |r| [r.try(:name), r.surname, r.organization.try(:name), r.dept, r.mail, r.phone, contact_actions(r, view_context, params[:eid])] }
    render json: {
      "draw":            params[:draw],
      "recordsTotal":    contacts.count,
      "recordsFiltered": contacts.count,
      "data":            results
    }
  end

  # GET /contacts
  def index
    @contacts = Contact.all
    @mails    = @contacts.where('`mail` > \'\'').pluck(:mail).uniq.join(', ') # get non-blank mail contacts
    @mails    = t(:empty) if @mails.blank?
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
    @my_contact_lists = @contact.contact_lists.pluck(:id)
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        unless params[:contact_list_ids].blank?
          params[:contact_list_ids].each do |id|
            @contact.contact_in_lists.create(contact_list_id: id)
          end
        end
        format.html { redirect_to @contact, success: "Kontakt  #{define_notice('m', __method__)}" }
        format.json { render :show, status: :created, location: @contact }
      else
        @contact_lists    = ContactList.all
        @my_contact_lists = @contact.contact_lists
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        @contact.contact_in_lists.destroy_all
        unless params[:contact_list_ids].blank?
          params[:contact_list_ids].each do |id|
            @contact.contact_in_lists.create(contact_list_id: id)
          end
        end
        format.html { redirect_to contacts_path, success: "Kontakt  #{define_notice('m', __method__)}" }
        format.json { render :show, status: :ok, location: @contact }
      else
        @contact_lists    = ContactList.all
        @my_contact_lists = @contact.contact_lists
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, success: "Kontakt  #{define_notice('m', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  def set_panel_variables
    @contact_lists              = current_user.employee.contact_lists
    @contact_lists_others       = ContactList.includes(employee: [:user]) - current_user.employee.contact_lists
    @organization_contact_count = Contact.joins(:organization).count
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :surname, :nickname, :mail, :phone, :other_contacts, :notes, :contact_list_ids)
  end
end
