class HomepageCardsController < ApplicationController
  before_action :set_homepage_card, only: [:toggle_is_visible, :show, :edit, :update, :destroy]
  layout 'page_part'

  # GET /homepage_cards
  def index
    @homepage_cards = HomepageCard.all
  end

  # PUT
  def toggle_is_visible
    @cards = HomepageCard.all
    @homepage_card.update(is_visible: !@homepage_card.is_visible)
    render 'homepage/edit_cards'
  end

  # POST /homepage_cards
  def create
    @cards         = HomepageCard.all
    @homepage_card = HomepageCard.new({ title: "Title", is_visible: false })
    @homepage_card.save
    render 'homepage/edit_cards'
  end

  # PATCH/PUT /homepage_cards/1
  def update
    respond_to do |format|
      if @homepage_card.update(homepage_card_params)
        format.html { redirect_to @homepage_card, notice: "#{t :card} #{define_notice('ž', __method__)}" }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /homepage_cards/1
  def destroy
    @cards = HomepageCard.all
    @homepage_card.destroy
    render 'homepage/edit_cards'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_homepage_card
    @homepage_card = HomepageCard.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def homepage_card_params
    params.require(:homepage_card).permit(:title, :url, :priority, :image_1, :image_2, :image_3, :image_4, :image_5, :is_visible)
  end
end
