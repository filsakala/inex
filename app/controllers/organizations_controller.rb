class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :set_panel, only: [:index, :show, :new, :edit]
  include Searchable
  include OrganizationsHelper

  def search
    if !params[:eid].blank?
      orgs = Organization.joins(:organization_in_networks).where(organization_in_networks: { partner_network_id: params[:eid] }).includes(:contacts, :partner_networks, :events)
    else
      orgs = Organization.includes(:contacts, :partner_networks, :events)
    end
    @flags  = Country.flag_codes_for_countries(orgs.pluck(:country))
    results = do_search(orgs, columns: [:name, :country], order_by: { name: :asc })
    results = results.collect { |r| [organization_name_link(r, view_context),
                                     org_country_with_flag(r),
                                     org_partner_networks(r, view_context),
                                     org_contacts(r, view_context),
                                     org_actions(r, view_context)] }
    render json: {
      "draw":            params[:draw],
      "recordsTotal":    Organization.count,
      "recordsFiltered": Organization.count,
      "data":            results
    }
  end

  # GET /organizations
  def index
    @organizations = Organization.includes(:events, :partner_networks, :contacts)
    @event_counts  = Event.group(:organization_id).count(:organization_id) # Event count for each org.
    @flags         = Country.flag_codes_for_countries(@organizations.pluck(:country))
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
    @countries    = Country.order(:name)
  end

  # GET /organizations/1/edit
  def edit
    @my_networks = @organization.partner_networks.pluck(:id)
    @countries   = Country.order(:name)
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        params[:network_ids].each do |pnid|
          @organization.organization_in_networks.create(partner_network_id: pnid)
        end if !params[:network_ids].blank?
        format.html { redirect_to organizations_path, success: "#{t(:organization)} #{define_notice('ž', __method__)}" }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /organizations/1
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        @organization.organization_in_networks.destroy_all
        params[:network_ids].each do |pnid|
          @organization.organization_in_networks.create(partner_network_id: pnid)
        end if !params[:network_ids].blank?
        format.html { redirect_to organizations_path, success: "#{t(:organization)} #{define_notice('ž', __method__)}" }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /organizations/1
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url, success: "#{t(:organization)} #{define_notice('ž', __method__)}" }
    end
  end

  private
  def set_panel
    @partner_networks = PartnerNetwork.order(:name)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_organization
    @organization = Organization.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organization_params
    params.require(:organization).permit(:name, :description, :country, :user_ids, :image, contacts_attributes: [:name, :nickname, :mail, :phone, :other_contacts, :notes, :dept, :id, :_destroy])
  end
end
