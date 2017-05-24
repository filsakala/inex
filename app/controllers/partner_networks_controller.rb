class PartnerNetworksController < ApplicationController
  before_action :set_partner_network, only: [:show, :edit, :update, :destroy]
  before_action :set_panel, only: [:index, :show, :new, :edit, :create, :update, :destroy]

  # GET /partner_networks
  # GET /partner_networks.json
  def index
  end

  # GET /partner_networks/1
  # GET /partner_networks/1.json
  def show
    @my_organizations = @partner_network.organizations.order(:name)
  end

  # GET /partner_networks/new
  def new
    @partner_network = PartnerNetwork.new
  end

  # GET /partner_networks/1/edit
  def edit
  end

  # POST /partner_networks
  # POST /partner_networks.json
  def create
    @partner_network = PartnerNetwork.new(partner_network_params)

    respond_to do |format|
      if @partner_network.save
        format.html { redirect_to @partner_network, success: "#{t :partner_network} #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :created, location: @partner_network }
      else
        format.html { render :new }
        format.json { render json: @partner_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /partner_networks/1
  # PATCH/PUT /partner_networks/1.json
  def update
    respond_to do |format|
      if @partner_network.update(partner_network_params)
        format.html { redirect_to @partner_network, success: "#{t :partner_network} #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :ok, location: @partner_network }
      else
        format.html { render :edit }
        format.json { render json: @partner_network.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /partner_networks/1
  # DELETE /partner_networks/1.json
  def destroy
    @partner_network.destroy
    respond_to do |format|
      format.html { redirect_to partner_networks_url, success: "#{t :partner_network} #{define_notice('ž', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_partner_network
    @partner_network = PartnerNetwork.find(params[:id])
  end

  def set_panel
    @organizations = Organization.includes(:events, :partner_networks, :contacts)
    @partner_networks = PartnerNetwork.includes(:organizations).order(:name)
    @event_counts = Event.group(:organization_id).count(:organization_id) # Event count for each org.
    @flags = {}
    Country.where(name: @organizations.pluck(:country)).each { |c| @flags[c.name] = c.flag_code }
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def partner_network_params
    params.require(:partner_network).permit(:name, :description)
  end
end
