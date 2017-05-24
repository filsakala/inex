class ParticipationFeesController < EmployeeController
  before_action :set_participation_fee, only: [:show, :edit, :update, :destroy]

  # GET /participation_fees
  # GET /participation_fees.json
  def index
    per_page = params[:per_page]
    per_page ||= 10
    page = params[:page] || 1
    participation_fees = do_search(params[:query])
    page = 1 if participation_fees.count < (page.to_i - 1) * (per_page.to_i) + 1
    @participation_fees = participation_fees.includes(:user, event_list: [event_in_lists: [event: [:event_type]]]).order("users.surname").order(date: :desc).paginate(page: page, per_page: per_page)
    @users = User.select(:id, :name, :surname, :login_mail, :personal_mail)
  end

  def search
    participation_fees = do_search(params[:q])
    res = participation_fees.collect { |u|
      {
        "title": "#{u.user.name} #{u.user.surname}",
        "url": participation_fee_path(u),
        "description": u.user.login_mail
      }
    }
    render json: {
      "results": res,
      "action": {
        "url": participation_fees_path(query: params[:q], page: params[:page], per_page: params[:per_page]),
        "text": "Obnoviť tabuľku (#{res.size} výsledkov)"
      }
    }
  end

  def do_search(query)
    t = ParticipationFee.arel_table
    if !query.blank?
      q = query.split(' ').join('|')
      ParticipationFee.joins(:user).where("`users`.`name` REGEXP ? OR `users`.`surname` REGEXP ? OR `users`.`login_mail` REGEXP ? OR `users`.`personal_mail` REGEXP ?", q, q, q, q)
    else
      ParticipationFee.all
    end
  end

  # GET /participation_fees/1
  # GET /participation_fees/1.json
  def show
  end

  # GET /participation_fees/new
  def new
    @participation_fee = ParticipationFee.new
    @users = User.all
    @user = User.find(params[:user_id]) if !params[:user_id].blank?
    if @user
      @user_bags = EventList.where(user_id: @user.id).where.not(state: 'opened').collect {
        |e|
        if e.event_type
          ["#{e.name} #{e.surname}, #{e.event_type.title}, #{e.created_at.strftime("%d.%m.%Y %H:%m")}", e.id]
        else
          [e.created_at, e.id]
        end
      }
    end
  end

  # GET /participation_fees/1/edit
  def edit
    @user = @participation_fee.user
    @user_bags = EventList.where(user_id: @user.id).where.not(state: 'opened').collect {
      |e|
      if e.event_type
        ["#{e.name} #{e.surname}, #{e.event_type.title}, #{e.created_at.strftime("%d.%m.%Y %H:%m")}", e.id]
      else
        [e.created_at, e.id]
      end
    }
    @users = User.all
  end

  # POST /participation_fees
  # POST /participation_fees.json
  def create
    @participation_fee = ParticipationFee.new(participation_fee_params)

    respond_to do |format|
      if @participation_fee.save
        event_type = @participation_fee.try(:event_list).try(:event_type)
        employee = event_type.try(:employee)
        if employee && event_type.can_send_registration_mail
          RegisteredBagMailer.added_payment_mail(employee, @participation_fee, "#{request.protocol}#{request.host_with_port}").deliver_now
        end
        format.html { redirect_to @participation_fee, success: "#{t :participation_fee} #{define_notice('m', __method__)}" }
        format.json { render :show, status: :created, location: @participation_fee }
      else
        @users = User.all
        format.html { render :new }
        format.json { render json: @participation_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /participation_fees/1
  # PATCH/PUT /participation_fees/1.json
  def update
    respond_to do |format|
      if @participation_fee.update(participation_fee_params)
        format.html { redirect_to participation_fees_path, success: "#{t :participation_fee} #{define_notice('m', __method__)}" }
        format.json { render :show, status: :ok, location: @participation_fee }
      else
        format.html { render :edit }
        format.json { render json: @participation_fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /participation_fees/1
  # DELETE /participation_fees/1.json
  def destroy
    @participation_fee.destroy
    respond_to do |format|
      format.html { redirect_to participation_fees_url, success: "#{t :participation_fee} #{define_notice('m', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_participation_fee
    @participation_fee = ParticipationFee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def participation_fee_params
    params.require(:participation_fee).permit(:user_id, :event_list_id, :amount, :date, :notes, :pay_type)
  end
end
