class PermissionsController < InexMemberController
  before_action :set_permission, only: [:show, :edit, :update, :destroy]

  def index
    @permissions = Permission.all
    @actions = Rails.application.routes.routes.map { |route| { controller: route.defaults[:controller], action: route.defaults[:action] } }.uniq
  end

  def toggle_permission
    controller = params[:con]
    action = params[:act]
    role = params[:role]
    permission = Permission.where(controller: controller, action: action, role: role)
    if permission.any?
      permission.destroy_all
    else
      Permission.create(controller: controller, action: action, role: role)
    end
    render :nothing => true
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new(permission_params)

    respond_to do |format|
      if @permission.save
        format.html { redirect_to @permission, notice: 'Permission was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @permission.update(permission_params)
        format.html { redirect_to @permission, notice: 'Permission was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @permission.destroy
    respond_to do |format|
      format.html { redirect_to permissions_url, notice: 'Permission was successfully destroyed.' }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_permission
    @permission = Permission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def permission_params
    params.fetch(:permission, {})
  end
end
