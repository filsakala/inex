module SessionsHelper

  def colored_labeled_icon_button(par = {})
    size = par[:size] if par[:size]
    color = par[:color] if par[:color]
    icon = par[:icon] if par[:icon]
    text = par[:text] if par[:text]
    "<div class=\"ui #{size} #{color} labeled icon button\">
      <i class=\"#{icon} icon\"></i>
      #{text}
    </div>"
  end
end
