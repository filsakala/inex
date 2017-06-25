class IssueTicketsController < InexMemberController
  before_action :set_issue_ticket, only: [:show, :set_done, :edit, :update, :destroy]

  # GET /issue_tickets
  def index
    @issue_tickets = IssueTicket.includes(:user).where('`is_done` IS NOT true')
    @issue_tickets_done = IssueTicket.includes(:user).where(is_done: true)
  end

  def set_done
    @issue_ticket.update(is_done: !@issue_ticket.is_done)
    redirect_to :back, success: 'Stav problému bol úspešne prestavený.'
  end

  # GET /issue_tickets/new
  def new
    @issue_ticket = IssueTicket.new
  end

  # POST /issue_tickets
  def create
    @issue_ticket = IssueTicket.new(issue_ticket_params)

    respond_to do |format|
      if @issue_ticket.save
        IssueTicketsMailer.created_issue(@issue_ticket, "#{request.protocol}#{request.host_with_port}").deliver_now
        format.html { redirect_to @issue_ticket, notice: 'Issue ticket was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /issue_tickets/1
  def update
    respond_to do |format|
      if @issue_ticket.update(issue_ticket_params)
        format.html { redirect_to @issue_ticket, notice: 'Issue ticket was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /issue_tickets/1
  def destroy
    @issue_ticket.destroy
    respond_to do |format|
      format.html { redirect_to issue_tickets_url, notice: 'Issue ticket was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_ticket
      @issue_ticket = IssueTicket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_ticket_params
      params.require(:issue_ticket).permit(:user_id, :description, :priority, :image)
    end
end
