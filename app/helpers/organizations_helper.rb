module OrganizationsHelper

  def organization_name_link(organization, view_context)
    view_context.link_to(organization.name, organization)
  end

  def org_country_with_flag(organization)
    "<i class=\"#{@flags[organization.country]} flag\"></i> #{organization.country}".html_safe
  end

  def org_partner_networks(organization, view_context)
    html = ""
    if organization.partner_networks.any?
      organization.partner_networks.each do |net|
        html << view_context.link_to(net.name, partner_network_path(net), class: 'ui blue label')
      end
    end
    html.html_safe
  end

  def org_contacts(organization, view_context)
    html = ""
    if organization.contacts.any?
      organization.contacts.each do |cp|
        html << view_context.link_to(contact_path(cp), class: 'ui label ', target: "_blank") do
          "<i class=\"ui user icon\"></i> #{cp.name}".html_safe
        end
      end
    end
    html.html_safe
  end

  def org_actions(organization, view_context)
    html = ""
    html = "<div class=\"ui teal dropdown item label\">
                <i class=\"setting icon\"></i> #{t :actions}
                <i class=\"dropdown icon\"></i>
                <div class=\"menu\">"
    html << view_context.link_to(organization, class: 'item') do
      "<i class=\"unhide icon\"></i> Detail".html_safe
    end
    html << view_context.link_to(edit_organization_path(organization), class: 'item') do
      "<i class=\"yellow edit icon\"></i> #{t :edit}".html_safe
    end
    html << view_context.link_to(organization, method: :delete, data: { confirm: t(:are_you_sure_organization) }, class: 'item') do
      "<i class=\"red remove icon\"></i> #{t :remove}".html_safe
    end
    html << "</div>"
    html.html_safe
  end
end
