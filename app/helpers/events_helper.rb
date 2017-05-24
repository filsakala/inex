module EventsHelper

  def text_or_icon(text)
    if text.blank?
      '<i class="large red warning sign icon"></i>'.html_safe
    else
      text
    end
  end

  def active_step_class(step)
    'active' if action_name == step
  end

  def print_travelling_with_icons(event)
    if !event.airport.blank? && !event.bus_train.blank?
      "<i class=\"plane icon\"></i><b>#{t :airport}:</b> #{event.airport}, <i class=\"bus icon\"></i><i class=\"train icon\"></i><b>#{t :bus_train_station}:</b> #{event.bus_train}"
    elsif !event.airport.blank?
      "<i class=\"plane icon\"></i><b>#{t :airport}:</b> #{event.airport}"
    elsif !event.bus_train.blank?
      "<i class=\"bus icon\"></i><i class=\"train icon\"></i><b>#{t :bus_train_station}:</b> #{event.bus_train}"
    end
  end

  def event_public_params_set(event)
    result = []
    lang = I18n.locale
    result << { name: 'vseobecne', title: t(:basic_description), icon: 'talk', content: event.send("introduction_#{lang}").try(:html_safe) } unless event.send("introduction_#{lang}").blank?
    result << { name: 'work', title: t(:type_of_work), icon: 'child', content: event.send("type_of_work_#{lang}").try(:html_safe) } unless event.send("type_of_work_#{lang}").blank?
    result << { name: 'study', title: t(:study_theme), icon: 'student', content: event.send("study_theme_#{lang}").try(:html_safe) } unless event.send("study_theme_#{lang}").blank?
    result << { name: 'accomodation', title: t(:accommodation), icon: 'hotel', content: event.send("accomodation_#{lang}").try(:html_safe) } unless event.send("accomodation_#{lang}").blank?
    result << { name: 'advert', title: t(:camp_advert), icon: 'newspaper', content: event.send("camp_advert_#{lang}").try(:html_safe) } unless event.send("camp_advert_#{lang}").blank?
    result << { name: 'language', title: t(:language_description), icon: 'talk outline', content: event.send("language_description_#{lang}").try(:html_safe) } unless event.send("language_description_#{lang}").blank?
    result << { name: 'requirements', title: t(:requirements), icon: 'tag', content: event.send("requirements_#{lang}").try(:html_safe) } unless event.send("requirements_#{lang}").blank?
    result << { name: 'location', title: t(:location), icon: 'street view', content: "<p><i class=\"home icon\"></i><b>#{t :address}:</b> #{text_or_icon event.address}, #{text_or_icon event.city}, #{text_or_icon event.country}</p>
<p>#{print_travelling_with_icons(event)}</p>
<p><i class=\"marker icon\"></i><b>GPS:</b> #{text_or_icon event.gps_latitude}, #{text_or_icon event.gps_longitude}</p>
<p>#{event.send("location_#{lang}")}</p>".html_safe } unless event.send("location_#{lang}").blank?
    result << { name: 'notes', title: t(:additional_camp_notes), icon: 'write', content: event.send("additional_camp_notes_#{lang}").try(:html_safe) } unless event.send("additional_camp_notes_#{lang}").blank?
    result
  end

  def get_city_from_event_list_or_its_user(event_list)
    if event_list.addresses.count == 1
      return event_list.addresses.first.city
    else
      pad = event_list.addresses.where(title: 'Permanent').take
      if pad
        return pad.city
      else # user data
        user = event_list.user
        if user
          if user.addresses.count == 1
            return user.addresses.first.city
          else
            pad = user.addresses.where(title: 'Permanent').take
            if pad
              return pad.city
            end
          end
        end
      end
    end
    return ""
  end

  def get_year_from_event_list_or_its_user(event_list)
    if !event_list.birth_date.blank?
      return event_list.birth_date.try(:year)
    else
      user = event_list.user
      if user
        if !user.birth_date.blank?
          return user.birth_date.try(:year)
        end
      end
    end
    return ""
  end
end