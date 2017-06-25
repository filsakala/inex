class UsersController < ApplicationController
  before_action :set_user, only: [:deactivate, :set_inex_member, :destroy_inex_member, :show, :my_applications, :my_events, :edit, :update, :destroy] # must be here!
  before_action :can_do_employee_things, only: [:index, :destroy, :deactivate, :set_inex_member]
  before_action :can_see_or_edit, only: [:show, :edit, :update]
  include Searchable
  include UsersHelper

  def index
    @employees = Employee.includes(:user)
  end

  # DataTable search
  def search
    results = do_search(User, columns: [:name, :surname, :login_mail, :personal_mail, :role], order_by: { surname: :asc })
    results = results.collect { |user| [user.name_surname_nickname, mail_links(binding), user_states(binding), user_actions(binding)] }
    render json: {
      "draw":            params[:draw],
      "recordsTotal":    User.count,
      "recordsFiltered": User.count,
      "data":            results
    }
  end

  def show
    @addresses = @user.addresses
  end

  def my_applications
    @my_bags = @user.event_lists.order(created_at: :desc).order(state: :asc)
  end

  def new
    @user = User.new
  end

  def set_inex_member
    @user.role = params[:user][:role]
    @user.save(validate: false)
    Employee.create(user: @user) if !@user.employee
    redirect_to users_path, success: t(:user_was_added_to_inex_office)
  end

  def destroy_inex_member
    @user.role = nil
    @user.save(validate: false)
    @user.employee.destroy
    redirect_to users_path, success: t(:user_was_removed_from_inex_office)
  end

  def deactivate
    if @user == current_user
      redirect_to users_path, warning: t(:you_cannot_deactivate_yourself)
    else
      if @user.is_active?
        if @user.is_inex_office?
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

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user, "#{request.protocol}#{request.host_with_port}").deliver_now
        format.html { redirect_to new_session_path, success: "#{t :you_were_registered_email_was_sent_to} #{@user.login_mail}." }
      else
        format.html { render :new }
      end
    end
  end

  def update
    if @user.password.blank? || @user.password_confirmation.blank?
      @user.perform_password_validation = false
    end
    respond_to do |format|
      if !current_user.is_employee? && params[:user] && (!params[:user][:name].blank? || !params[:user][:surname].blank?)
        @user.errors.add(:name, t(:you_cannot_edit_name))
        @user.errors.add(:surname, t(:you_cannot_edit_surname))
        format.html { render :edit }
      else
        if @user.update(user_params)
          format.html { redirect_to @user, success: "#{t :user} #{define_notice('m', __method__)}" }
        else
          @educations = Education.all
          format.html { render :edit }
        end
      end
    end
  end

  def destroy
    if session[:user_id] == @user.id
      redirect_to :back, error: "Nemôžeš vymazať sám seba. Požiadaj niekoho iného :)"
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, success: "#{t :user} #{define_notice('m', __method__)}" }
      end
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
