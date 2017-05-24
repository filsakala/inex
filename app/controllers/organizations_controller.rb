class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.includes(:events, :partner_networks, :contacts)
    @partner_networks = PartnerNetwork.includes(:organizations).order(:name)
    @event_counts = Event.group(:organization_id).count(:organization_id) # Event count for each org.
    @flags = {}
    Country.where(name: @organizations.pluck(:country)).each { |c| @flags[c.name] = c.flag_code }
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @events = @organization.events
    @organizations = Organization.all
    @partner_networks = PartnerNetwork.includes(:organizations).order(:name)
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @networks = PartnerNetwork.all
    @countries = Country.order(:name)
    @organizations = Organization.all
    @partner_networks = PartnerNetwork.includes(:organizations).order(:name)
  end

  # GET /organizations/1/edit
  def edit
    @networks = PartnerNetwork.all
    @my_networks = @organization.partner_networks.pluck(:id)
    @countries = Country.order(:name)
    @organizations = Organization.all
    @partner_networks = PartnerNetwork.includes(:organizations).order(:name)
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        if !params[:network_ids].blank?
          networks = PartnerNetwork.find(params[:network_ids])
          networks.each do |network|
            @organization.save
            @organization.organization_in_networks.create(partner_network: network)
          end
        end
        format.html { redirect_to organizations_path, success: "#{t(:organization)} #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :created, location: @organization }
      else
        @networks = PartnerNetwork.all
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        @organization.organization_in_networks.destroy_all
        if !params[:network_ids].blank?
          networks = PartnerNetwork.find(params[:network_ids])
          networks.each do |network|
            @organization.save
            @organization.organization_in_networks.create(partner_network: network)
          end
        end
        format.html { redirect_to organizations_path, success: "#{t(:organization)} #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :ok, location: @organization }
      else
        @networks = PartnerNetwork.all
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, success: "#{t(:organization)} #{define_notice('ž', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_params
    params.require(:organization).permit(:name, :description, :country, :user_ids, :image, contacts_attributes: [:name, :nickname, :mail, :phone, :other_contacts, :notes, :dept, :id, :_destroy])
  end
end
