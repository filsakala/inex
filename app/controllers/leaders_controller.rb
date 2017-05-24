class LeadersController < ApplicationController
  before_action :set_leader, only: [:show, :edit, :update, :destroy]

  # GET /leaders
  # GET /leaders.json
  def index
    @leaders = Leader.all
  end

  # GET /leaders/1
  # GET /leaders/1.json
  def show
  end

  # GET /leaders/new
  def new
    @leader = Leader.new
  end

  # GET /leaders/1/edit
  def edit
  end

  # POST /leaders
  # POST /leaders.json
  def create
    @leader = Leader.new(leader_params)

    respond_to do |format|
      if @leader.save
        format.html { redirect_to @leader, success: "#{t :leader} #{define_notice('m', __method__)}" }
        format.json { render :show, status: :created, location: @leader }
      else
        format.html { render :new }
        format.json { render json: @leader.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /leaders/1
  # PATCH/PUT /leaders/1.json
  def update
    respond_to do |format|
      if @leader.update(leader_params)
        format.html { redirect_to @leader, success: "#{t :leader} #{define_notice('m', __method__)}" }
        format.json { render :show, status: :ok, location: @leader }
      else
        format.html { render :edit }
        format.json { render json: @leader.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leaders/1
  # DELETE /leaders/1.json
  def destroy
    @leader.destroy
    respond_to do |format|
      format.html { redirect_to leaders_url, success: "#{t :leader} #{define_notice('m', __method__)}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_leader
      @leader = Leader.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def leader_params
      params.fetch(:leader, {})
    end
end
