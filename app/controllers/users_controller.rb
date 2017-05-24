class UsersController < ApplicationController
  before_action :set_user, only: [:deactivate, :set_inex_member, :destroy_inex_member, :show, :show_bags, :show_events, :edit, :update, :destroy] # must be here!
  before_action :can_do_employee_things, only: [:index, :destroy, :deactivate, :set_inex_member]
  before_action :can_see_or_edit, only: [:show, :edit, :update]

  # GET /users
  # GET /users.json
  def index
    per_page = params[:per_page]
    per_page ||= 10
    page = params[:page] || 1
    users = do_search(params[:query])
    if users.count < (page.to_i - 1) * (per_page.to_i) + 1
      page = 1
    end
    @users = users.paginate(page: page, per_page: per_page)
    @employees = Employee.all
  end

  def search
    users = do_search(params[:q])
    res = users.collect { |u|
      {
        "title": "#{u.name} #{u.surname}",
        "url": user_path(u),
        "description": u.login_mail
      }
    }
    render json: {
      "results": res,
      "action": {
        "url": users_path(query: params[:q], page: params[:page], per_page: params[:per_page]),
        "text": "Obnoviť tabuľku (#{res.size} výsledkov)"
      }
    }
  end

  def do_search(query)
    t = User.arel_table
    if !query.blank?
      q = query.split(' ').join('|')
      User.where("`name` REGEXP ? OR `surname` REGEXP ? OR `login_mail` REGEXP ? OR `personal_mail` REGEXP ? OR `role` REGEXP ?", q, q, q, q, q)
    else
      User.all
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @addresses = @user.addresses
  end

  def show_events
    @leaders = @user.leaders
    @trainers = @user.trainers
    @local_partners = @user.local_partners
    @volunteers = @user.volunteers
  end

  def show_bags
    @my_bags = @user.event_lists.order(created_at: :desc).order(state: :asc)
  end

  # GET /users/new
  def new
    @user = User.new
    @educations = Education.all
  end

  # GET /users/1/edit
  def edit
    @educations = Education.all
  end

  # GET/POST
  def set_inex_member
    unless params[:commit].blank?
      @user.role = params[:user][:role]
      @user.save(validate: false)
      Employee.create(user: @user) if !@user.employee
      redirect_to users_path, success: t(:user_was_added_to_inex_office)
    end
  end

  # DELETE
  def destroy_inex_member
    @user.role = nil
    @user.save(validate: false)
    @user.employee.destroy
    redirect_to users_path, success: t(:user_was_removed_from_inex_office)
  end

  # PATCH
  def deactivate
    if @user == current_user
      redirect_to users_path, warning: t(:you_cannot_deactivate_yourself)
    else
      if @user.is_active?
        if @user.is_inex_member?
          if Employee.joins(:user).where(users: { state: "aktívny" }).count +
            Employee.joins(:user).where(users: { state: "active" }).count > 1
            @user.state = "neaktívny"
            @user.save(validate: false)
            redirect_to users_path, success: t(:user_was_deactivated)
          else
            redirect_to users_path, warning: t(:at_least_one_employee_should_be_active)
          end
        else
          @user.state = "neaktívny"
          @user.save(validate: false)
          redirect_to users_path, success: t(:user_was_deactivated)
        end
      else
        @user.state = "aktívny"
        @user.save(validate: false)
        redirect_to users_path, success: t(:user_was_activated)
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user, "#{request.protocol}#{request.host_with_port}").deliver_now
        format.html { redirect_to new_session_path, success: "#{t :you_were_registered_email_was_sent_to} #{@user.login_mail}." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.password.blank? || @user.password_confirmation.blank?
      @user.perform_password_validation = false
    end
    respond_to do |format|
      if !current_user.is_employee? && params[:user] && (!params[:user][:name].blank? || !params[:user][:surname].blank?)
        @educations = Education.all
        @user.errors.add(:name, t(:you_cannot_edit_name))
        @user.errors.add(:surname, t(:you_cannot_edit_surname))
        format.html { render :edit }
      else
        if @user.update(user_params)
          format.html { redirect_to @user, success: "#{t :user} #{define_notice('m', __method__)}" }
          format.json { render :show, status: :ok, location: @user }
        else
          @educations = Education.all
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if session[:user_id] == @user.id
      redirect_to :back, error: "Nemôžeš vymazať sám seba. Požiadaj niekoho iného :)"
    end
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, success: "#{t :user} #{define_notice('m', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def can_see_or_edit
    if current_user != @user && !current_user.is_employee?
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end

  def can_do_employee_things
    unless current_user.is_employee?
      redirect_to root_path, error: t(:you_dont_have_permissions_to_perform_this_action)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:login_mail, :password, :password_confirmation,
                                 :name, :surname, :nickname, :personal_mail, :personal_phone, :other_contacts,
                                 :sex, :birth_date, :place_of_birth, :nationality, :occupation,
                                 :terms_of_service, :education_id,
                                 addresses_attributes: [:id, :address, :city, :country, :postal_code, :title, :_destroy])
  end
end
