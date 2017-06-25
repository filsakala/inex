class HtmlArticlesController < ApplicationController
  before_action :set_html_article, only: [:mercury_update, :edit_card_put, :show, :edit, :update, :destroy]
  layout 'page_part'

  # GET /html_articles/1
  def show
    @recommender = Recommender.find_or_create_by(html_article: @html_article)
  end

  # GET /html_articles/new
  def new
    @html_article = HtmlArticle.new(content: "<h1>Default title</h1> This is default content.")
  end

  # POST /html_articles
  def create
    @html_article = HtmlArticle.new(html_article_params)
    @html_article.category = params[:category]

    respond_to do |format|
      if @html_article.save
        if @html_article.url.blank?
          format.html { redirect_to '/editor' + html_article_path(@html_article), success: "#{t :article} #{define_notice('m', __method__)}" }
        else
          format.html { redirect_to root_path, success: "Link  #{define_notice('m', __method__)}" }
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /html_articles/1
  def update
    respond_to do |format|
      if @html_article.update(html_article_params)
        if @html_article.url.blank?
          format.html { redirect_to html_article_path(@html_article), success: "#{t :article}  #{define_notice('m', __method__)}" }
        else
          format.html { redirect_to root_path, success: "Link  #{define_notice('m', __method__)}" }
        end
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /html_articles/1
  def destroy
    @html_article.destroy
    respond_to do |format|
      format.html { redirect_to root_path, success: "#{t :article}  #{define_notice('m', __method__)}" }
    end
  end

  # PUT
  def mercury_update
    @html_article.update(content: params[:content][:article][:value])
    render text: ''
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_html_article
    @html_article = HtmlArticle.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def html_article_params
    params.require(:html_article).permit(:category, :content, :url, :title)
  end
end
