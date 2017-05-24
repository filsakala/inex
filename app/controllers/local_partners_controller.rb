class LocalPartnersController < ApplicationController
  before_action :set_local_partner, only: [:show, :edit, :update, :destroy]

  # GET /local_partners
  # GET /local_partners.json
  def index
    @local_partners = LocalPartner.all
  end

  # GET /local_partners/1
  # GET /local_partners/1.json
  def show
  end

  # GET /local_partners/new
  def new
    @local_partner = LocalPartner.new
  end

  # GET /local_partners/1/edit
  def edit
  end

  # POST /local_partners
  # POST /local_partners.json
  def create
    @local_partner = LocalPartner.new(local_partner_params)

    respond_to do |format|
      if @local_partner.save
        format.html { redirect_to @local_partner, success: "#{t(:local_partner)} #{define_notice('m', __method__)}" }
        format.json { render :show, status: :created, location: @local_partner }
      else
        format.html { render :new }
        format.json { render json: @local_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /local_partners/1
  # PATCH/PUT /local_partners/1.json
  def update
    respond_to do |format|
      if @local_partner.update(local_partner_params)
        format.html { redirect_to @local_partner, success: "#{t(:local_partner)} #{define_notice('m', __method__)}" }
        format.json { render :show, status: :ok, location: @local_partner }
      else
        format.html { render :edit }
        format.json { render json: @local_partner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /local_partners/1
  # DELETE /local_partners/1.json
  def destroy
    @local_partner.destroy
    respond_to do |format|
      format.html { redirect_to local_partners_url, success: "#{t(:local_partner)} #{define_notice('m', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_local_partner
      @local_partner = LocalPartner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def local_partner_params
      params.fetch(:local_partner, {})
    end
end
