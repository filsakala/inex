module SessionsHelper

  def colored_labeled_icon_button(params = {})
    "<div class=\"ui #{params[:size]} #{params[:color]} labeled icon button\">
      <i class=\"#{params[:icon]} icon\"></i>
      #{params[:text]}
    </div>"
  end
end
