module ContactsHelper
  def name_nickname_format(contact)
    unless contact.nickname.blank?
      "#{contact.name} #{contact.surname} (#{contact.nickname})"
    else
      "#{contact.name} #{contact.surname}"
    end
  end

  def contact_actions(contact, view_context, contact_list)
    html = ""
    html = "<div class=\"ui teal dropdown item label\">
                <i class=\"setting icon\"></i> #{t :actions}
                <i class=\"dropdown icon\"></i>
                <div class=\"menu\">"
    html << view_context.link_to(contact, class: 'item') do
      '<i class="unhide link icon"></i> Detail'.html_safe
    end
    html << view_context.link_to(edit_contact_path(contact), class: 'item') do
      "<i class=\"yellow edit link icon\"></i> #{t :edit}".html_safe
    end
    if contact_list.blank?
      html << view_context.link_to(contact, method: :delete, data: { confirm: t(:are_you_sure_contact) }, class: 'item') do
        "<i class=\"red remove link icon\"></i> #{t :remove}".html_safe
      end
    elsif contact_list != "0" # partner networks
      html << view_context.link_to(remove_contact_contact_list_path(contact, contact_list),
                                   method: :delete,
                                   data: { confirm: t(:are_you_sure_contact_from_contact_list) },
                                   class: 'item') do
        "<i class=\"red remove link icon\"></i> #{t :remove}".html_safe
      end
    end
    html << "</div>"
    html.html_safe
  end
end
