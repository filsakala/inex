class KnowledgeCategoriesController < EmployeeController
  before_action :set_knowledge_category, only: [:show, :edit, :update, :destroy]

  # GET /knowledge_categories
  # GET /knowledge_categories.json
  def index
    @knowledge_categories = KnowledgeCategory.all
    @knowledges_without_category = Knowledge.all - Knowledge.joins(:knowledge_in_categories)
  end

  # GET /knowledge_categories/1
  # GET /knowledge_categories/1.json
  # def show
  # end

  # GET /knowledge_categories/new
  def new
    @knowledge_category = KnowledgeCategory.new
  end

  # GET /knowledge_categories/1/edit
  def edit
  end

  # POST /knowledge_categories
  # POST /knowledge_categories.json
  def create
    @knowledge_category = KnowledgeCategory.new(knowledge_category_params)

    respond_to do |format|
      if @knowledge_category.save
        format.html { redirect_to knowledge_categories_url, success: 'Knowledge category was successfully created.' }
        format.json { render :show, status: :created, location: @knowledge_category }
      else
        format.html { render :new }
        format.json { render json: @knowledge_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /knowledge_categories/1
  # PATCH/PUT /knowledge_categories/1.json
  def update
    respond_to do |format|
      if @knowledge_category.update(knowledge_category_params)
        format.html { redirect_to knowledge_categories_url, success: 'Knowledge category was successfully updated.' }
        format.json { render :show, status: :ok, location: @knowledge_category }
      else
        format.html { render :edit }
        format.json { render json: @knowledge_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /knowledge_categories/1
  # DELETE /knowledge_categories/1.json
  def destroy
    @knowledge_category.destroy
    respond_to do |format|
      format.html { redirect_to knowledge_categories_url, success: 'Knowledge category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_knowledge_category
      @knowledge_category = KnowledgeCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def knowledge_category_params
      params.require(:knowledge_category).permit(:category)
    end
end
