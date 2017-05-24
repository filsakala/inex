class KnowledgesController < EmployeeController
  before_action :set_knowledge, only: [:mercury_update, :show, :edit, :update, :destroy]
  before_action :can_see_knowledge, only: [:mercury_update, :show, :edit, :update, :destroy]

  # GET /knowledges
  # GET /knowledges.json
  def index
    @knowledges = Knowledge.all
  end

  # GET /knowledges/1
  # GET /knowledges/1.json
  def show
  end

  # GET /knowledges/new
  def new
    @knowledge = Knowledge.new
    @knowledge_categories = KnowledgeCategory.all
  end

  # GET /knowledges/1/edit
  def edit
    @knowledge_categories = KnowledgeCategory.all
    @my_categories = @knowledge.knowledge_categories.pluck(:id)
    @employees = Employee.joins(:user).select(:id, :nickname)
    @my_employees = @knowledge.employees.pluck(:id)
  end

  # POST /knowledges
  # POST /knowledges.json
  def create
    @knowledge = Knowledge.new(knowledge_params)

    respond_to do |format|
      if @knowledge.save
        unless params[:category_ids].blank?
          params[:category_ids].each do |id|
            @knowledge.knowledge_in_categories.create(knowledge_category_id: id)
          end
        end
        format.html { redirect_to knowledge_categories_url, success: "Znalosť  #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :created, location: @knowledge }
      else
        @knowledge_categories = KnowledgeCategory.all
        @my_categories = @knowledge.knowledge_categories.pluck(:id)
        format.html { render :new }
        format.json { render json: @knowledge.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST
  def mercury_update
    knowledge_params = {
      title: params[:content][:title][:value],
      text: params[:content][:text][:value],
      keywords: params[:content][:keywords][:value]
    }
    @knowledge.update(knowledge_params)
    render text: ''
  end

  # PATCH/PUT /knowledges/1
  # PATCH/PUT /knowledges/1.json
  def update
    respond_to do |format|
      if @knowledge.update(knowledge_params)
        @knowledge.knowledge_categories.destroy_all
        unless params[:category_ids].blank?
          params[:category_ids].each do |id|
            @knowledge.knowledge_in_categories.create(knowledge_category_id: id)
          end
        end
        @knowledge.employees.destroy_all
        unless params[:employee_ids].blank?
          params[:employee_ids].each do |id|
            @knowledge.employee_with_knowledges.create(employee_id: id)
          end
        end
        format.html { redirect_to knowledge_categories_url, success: "Znalosť  #{define_notice('ž', __method__)}" }
        format.json { render :show, status: :ok, location: @knowledge }
      else
        @knowledge_categories = KnowledgeCategory.all
        @my_categories = @knowledge.knowledge_categories.pluck(:id)
        format.html { render :edit }
        format.json { render json: @knowledge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /knowledges/1
  # DELETE /knowledges/1.json
  def destroy
    @knowledge.destroy
    respond_to do |format|
      format.html { redirect_to knowledge_categories_url, success: "Znalosť  #{define_notice('ž', __method__)}" }
      format.json { head :no_content }
    end
  end

  private

  def can_see_knowledge
    if !@knowledge.employees.blank? && !@knowledge.employees.include?(current_user.employee)
      redirect_to knowledge_categories_path, error: "Nemáš prístup k tomuto know-how."
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_knowledge
    @knowledge = Knowledge.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def knowledge_params
    params.require(:knowledge).permit(:title, :text, :keywords, :category_ids, :employee_ids)
  end
end
