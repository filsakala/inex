module HomepageHelper

  def number_as_word(number)
    %w(zero one two three four five six seven eight)[number] || number.to_s
  end

  def link_to_set_language
    language = if I18n.locale == :sk then "English" else "Slovensky" end
    flag = if I18n.locale == :sk then "gb" else "sk" end
    link_to_icon_span "inverted #{flag} flag", "white-text", language, set_lang_homepage_index_path, class: 'item'
  end

  def link_to_profile_or_login
    if current_user
      link_to_icon_span "inverted user icon", "white-text", current_user.nickname_or_name, current_user, class: 'active green item'
    else
      link_to_icon_span "inverted sign in icon", "white-text", t(:log_in), new_session_path, class: 'active green item'
    end
  end

  def link_to_new_article(category)
    if current_user && current_user.is_employee?
      link_to new_html_article_path(category), class: 'pop_up', title: "Pridať článok sem." do
        content_tag :i, '', class: 'green right floated plus circle link icon'
      end
    end
  end

  def ui_list_tags(category)
    content_tag :div, class: 'ui list' do
      @articles[category].each do |article|
        concat link_to_show_url(article)
      end
    end
  end

  def events_ajax_previous_link
    ->(param, date_range) { link_to raw("&laquo;"), { param => date_range.first - 1.day }, remote: :true }
  end

  def events_ajax_next_link
    ->(param, date_range) { link_to raw("&raquo;"), { param => date_range.last + 1.day }, remote: :true }
  end

  def meeting_html(meetings = [], view_context = nil)
    html = '<div class="ui divided items">'
    meetings.each do |meeting|
      html << '<div class="item"><div class="content"><div class="header">' # header start
      if !meeting.code.blank?
        html << meeting.code
      elsif !meeting.code_alliance.blank?
        html << meeting.code_alliance
      end
      html << view_context.link_to(" #{meeting.translated_title}", show_public_event_path(meeting), target: :blank, class: "item")
      html << " <i class=\"" << @flags[meeting.country].to_s << " flag\"></i>"
      if meeting.ignore_sex_for_capacity
        html << " <i class=\"users icon pop_up\" title=\"Celková kapacita\"></i>: #{meeting.free_total}"
      else
        html << "<i class=\"male icon pop_up\" title=\"#{t :free_places} - #{t :men}\"></i>: #{meeting.free_men}, "
        html << "<i class=\"female icon pop_up\" title=\"#{t :free_places} - #{t :women}\"></i>: #{meeting.free_women}"
      end
      html << '</div>' # header ending
      html << '<div class="meta"><span>'
      html << meeting.from_to
      html << '</span></div><div class="extra">'
      unless meeting.event_categories.blank?
        meeting.event_categories.each do |category|
          html << "<span class=\"ui green label pop_up\" title=\"#{category.name}\">#{category.abbr}</span>"
        end
      end
      html << '</div></div></div>'
    end
    html << '</div>'
    html
  end

  def meetings_ajax(meetings = [])
    ->() { meeting_html(meetings) }
  end
end
