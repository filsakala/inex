class ImportWorkcampsController < ApplicationController
  before_action :set_import_workcamp, only: [:show, :edit, :update, :destroy]
  layout 'page_part'

  # GET /import_workcamps
  # GET /import_workcamps.json
  def index
    @import_workcamps = ImportWorkcamp.all
  end

  def import
    if params[:commit] && params[:file].blank?
      redirect_to :back, warning: 'Nebol vybraný súbor.'
    end
    if params[:commit] && !params[:file].blank?
      tmp = params[:file].tempfile
      @path = File.join("public", "system", "files", "import_workcamps", "#{DateTime.now}_#{params[:file].original_filename}")
      FileUtils.cp tmp.path, @path
      if File.extname(@path) == '.csv'
        @results = []
        CSV.foreach(@path, :col_sep => ";", headers: true) do |row|
          js = "javascript:"
          row.each do |header, value|
            if header == "country_id"
              c = ImportWorkcamp.find_code_for_country_name(value)
              js += "document.getElementsByName('#{header}')[0].value = #{c.keys.join("").to_i};"
            elsif header == "active"
              if value == "true" || value == "1"
                js += "CMSadmin.GScheckbox('ch_6_active','chl_6_active');"
              end
            elsif header == "is_special"
              if value == "true" || value == "1"
                js += "CMSadmin.GScheckbox('ch_7_special','chl_7_special');"
              end
            elsif header == "allimportcodes[]"
              unless value.blank?
                options = value.delete(' ').split(',')
                options.each do |o|
                  js_tmp = "option = document.createElement( 'option' );"
                  js_tmp += "option.value = option.text = '#{o}';"
                  js_tmp += "document.getElementsByName('#{header}')[0].add( option );"
                  js += js_tmp
                end
              end
            elsif header == "description"
              js += "tinyMCE.get('description').setContent('#{value}');"
            elsif header == "notes"
              js += "tinyMCE.get('notes').setContent('#{value}');"
            else
              js += "document.getElementsByName('#{header}')[0].setAttribute('value', '#{value}');"
            end
          end
          @results << js
        end
      else
        redirect_to :back, notice: 'Nebol vybraný súbor .csv'
      end
    end
  end

  # GET /import_workcamps/1
  # GET /import_workcamps/1.json
  def show
  end

  # GET /import_workcamps/new
  def new
    @import_workcamp = ImportWorkcamp.new
  end

  # GET /import_workcamps/1/edit
  def edit
  end

  # POST /import_workcamps
  # POST /import_workcamps.json
  def create
    @import_workcamp = ImportWorkcamp.new(import_workcamp_params)

    respond_to do |format|
      if @import_workcamp.save
        format.html { redirect_to @import_workcamp, notice: 'Import workcamp was successfully created.' }
        format.json { render :show, status: :created, location: @import_workcamp }
      else
        format.html { render :new }
        format.json { render json: @import_workcamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /import_workcamps/1
  # PATCH/PUT /import_workcamps/1.json
  def update
    respond_to do |format|
      if @import_workcamp.update(import_workcamp_params)
        format.html { redirect_to @import_workcamp, notice: 'Import workcamp was successfully updated.' }
        format.json { render :show, status: :ok, location: @import_workcamp }
      else
        format.html { render :edit }
        format.json { render json: @import_workcamp.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /import_workcamps/1
  # DELETE /import_workcamps/1.json
  def destroy
    @import_workcamp.destroy
    respond_to do |format|
      format.html { redirect_to import_workcamps_url, notice: 'Import workcamp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_import_workcamp
    @import_workcamp = ImportWorkcamp.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def import_workcamp_params
    params.fetch(:import_workcamp, {})
  end
end
