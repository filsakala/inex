class HomepageCardsController < ApplicationController
  before_action :set_homepage_card, only: [:toggle_is_visible, :show, :edit, :update, :destroy]
  layout 'page_part'

  # GET /homepage_cards
  # GET /homepage_cards.json
  def index
    @homepage_cards = HomepageCard.all
  end

  # GET /homepage_cards/1
  # GET /homepage_cards/1.json
  def show
  end

  # GET /homepage_cards/new
  # def new
  #   @homepage_card = HomepageCard.new
  # end

  # GET /homepage_cards/1/edit
  def edit
  end

  # PUT
  def toggle_is_visible
    @cards = HomepageCard.all
    @homepage_card.update(is_visible: !@homepage_card.is_visible)
    render 'homepage/edit_cards'
  end

  # POST /homepage_cards
  # POST /homepage_cards.json
  def create
    @cards = HomepageCard.all
    @homepage_card = HomepageCard.new({ title: "Title",
                                        is_visible: false
                                      })
    @homepage_card.save
    render 'homepage/edit_cards'
  end

  # PATCH/PUT /homepage_cards/1
  # PATCH/PUT /homepage_cards/1.json
  def update
    respond_to do |format|
      if @homepage_card.update(homepage_card_params)
        format.html { redirect_to @homepage_card, notice: "#{t :card} #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :ok, location: @homepage_card }
      else
        format.html { render :edit }
        format.json { render json: @homepage_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /homepage_cards/1
  # DELETE /homepage_cards/1.json
  def destroy
    @cards = HomepageCard.all
    # move next positions -1
    # next_cards = HomepageCard.where("priority > ?", @homepage_card.priority)
    # next_cards.each do |n|
    #   n.update(priority: n.priority - 1)
    # end
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
