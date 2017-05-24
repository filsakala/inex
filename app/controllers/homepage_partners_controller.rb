class HomepagePartnersController < ApplicationController
  layout 'page_part'
  before_action :set_partner, only: [:edit, :update, :destroy]

  def index

  end

  def new
    @partner = HomepagePartner.new
  end

  def edit
  end

  def create
    @partner = HomepagePartner.new(homepage_partner_params)
    @partner.save
    redirect_to root_path, success: "Partner  #{define_notice('m', __method__)}"
  end

  def update
    @partner.update(homepage_partner_params)
    redirect_to root_path, success: "Partner  #{define_notice('m', __method__)}"
  end

  def destroy
    @partner.destroy
    redirect_to root_path, success: "Partner  #{define_notice('m', __method__)}"
  end

  private
  def set_partner
    @partner = HomepagePartner.find(params[:id])
  end

  def homepage_partner_params
    params.require(:homepage_partner).permit(:img_url, :text, :url, :image)
  end
end
