class IActivity < DatabaseTransformator
  self.table_name = "i_activity"
  # Ignore: parentclass, parentprop, parentid, pos, deletedtime, deleteduser, createduser, modifieduser, _newsa_id
  # OK: id, createdtime (int!), modifiedtime (int!), _title, _title_en, _text, _text_en,
  # _date_from_timestamp (int!), _date_to_timestamp (int!), _all_day, _perex, _perex_en
  # Transformuj do events, event type je jednorazove akcie (aj ked zalezi, niektore by mohli byt vzdelavacie a pod.)

  def self.transform
    event_type = EventType.where(title: 'Zo zálohy: Aktivity').take
    if !event_type
      set = SuperEventType.where(name: 'Dobrovoľnícke').take
      set = SuperEventType.create(name: 'Dobrovoľnícke') if !set
      event_type = EventType.create(title: 'Zo zálohy: Aktivity', super_event_type_id: set.id)
    end
    IActivity.all.each do |activity|
      event = Event.new(
        event_type_id: event_type.id,
        created_at: activity.createdtime,
        updated_at: activity.modifiedtime,
        title: activity._title,
        title_en: activity._title__en,
        from: DateTime.strptime(activity._date_from_timestamp.to_s,'%s'),
        to: DateTime.strptime(activity._date_to_timestamp.to_s,'%s'),
        is_only_date: activity._all_day,
        introduction_sk: activity._text,
        introduction_en: activity._text__en,
        additional_camp_notes_sk: activity._perex,
        additional_camp_notes_en: activity._perex__en
      )
      if event.title.blank?
        if !event.title_en.blank?
          event.title = event.title_en
          event.errors.add(:title, "W: Názov EN bol skopírovaný do názvu SK")
        else
          event.title = "Nevyplnený názov"
          event.errors.add(:title, "Názov musí byť zadaný.")
        end
      end
      # Save message to log
      if event.save
        # success_message = "Success, id: #{event.id}"
        # if event.errors.any?
        #   success_message += ", warning: " + event.errors.full_messages.join(', ')
        # end
        # LogActivity.create(action: "Transformation: Activity -> Event", what: success_message)
      else
        error_message = ""
        if event.errors.any?
          error_message = event.errors.full_messages.join(', ')
        end
        LogActivity.create(action: "Transformation: Activity -> Event", what: "Error, message: #{error_message}")
      end
    end
  end
end