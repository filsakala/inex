module HomepageHelper

  def number_as_word(number)
    case number
      when 0
        'zero'
      when 1
        'one'
      when 2
        'two'
      when 3
        'three'
      when 4
        'four'
      when 5
        'five'
      when 6
        'six'
      when 7
        'seven'
      when 8
        'eight'
      else
        number.to_s
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

  def meeting_html(meetings = [])
    html = '<div class="ui divided items">'
    meetings.each do |meeting|
      html << '<div class="item"><div class="content"><div class="header">' # header start
      html << meeting.code if meeting.code
      html << link_to(" #{meeting.title}", show_public_event_path(meeting), target: :blank, class: "item")
      country = Country.find_by_name(meeting.country) if !meeting.country.blank?
      html << " <i class=\"" << country.try(:flag_code) << " flag\"></i>" if country
      if meeting.ignore_sex_for_capacity
        html << "<i class=\"users icon pop_up\" title=\"Celková kapacita\"></i>: #{meeting.free_total}"
      else
        html << "<i class=\"male icon pop_up\" title=\"#{t :free_places} - #{t :men}\"></i>: #{meeting.free_men}, "
        html << "<i class=\"female icon pop_up\" title=\"#{t :free_places} - #{t :women}\"></i>: #{meeting.free_women}"
      end
      html << '</div>' # header ending
      html << '<div class="meta"><span>'
      if meeting.is_only_date
        html << date_format(meeting.from)
        html << " - "
        html << date_format(meeting.to)
      else
        html << datetime_format(meeting.from)
        html << " - "
        html << datetime_format(meeting.to)
      end
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
