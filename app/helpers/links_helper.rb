module LinksHelper

  def link_to_icon(icon, path, **args)
    link_to path, args do
      content_tag :i, nil, class: "#{icon} icon"
    end
  end

  def link_to_icon_text(icon, text, path, **args)
    link_to path, args do
      [
        content_tag(:i, nil, class: "#{icon} icon"),
        text
      ].join.html_safe
    end
  end

  # Homepage
  def link_to_icon_span(icon, span_class, text, path, **args)
    link_to path, args do
      [
        content_tag(:i, nil, class: "#{icon}"),
        content_tag(:span, text, class: span_class)
      ].join.html_safe
    end
  end

  def if_is_inex_office(then_val = "", else_val = "")
    if current_user.try(:is_inex_office?)
      then_val
    else
      else_val
    end
  end
end
