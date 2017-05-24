class EventImporter
  require 'csv'
  require 'rails_extensions.rb' # Hash.dig
  attr_accessor :file

  def initialize(file)
    @file = file
  end

  # Usable columns
  def event_columns
    ["accomodation_en", "accomodation_sk", "additional_camp_notes_en",
     "additional_camp_notes_sk", "address", "airport", "bus_train", "camp_advert_en",
     "camp_advert_sk", "can_create_member_registration", "capacity_men", "capacity_total",
     "capacity_women", "city", "code", "code_alliance", "country", "employee",
     "event_category", "event_document", "extra_fee", "fees_en", "fees_sk",
     "free_men", "free_total", "free_women", "from", "gps_latitude", "gps_longitude",
     "ignore", "ignore_sex_for_capacity", "introduction_en", "introduction_sk",
     "is_cancelled", "language_description_en", "language_description_sk",
     "location_en", "location_sk", "max_age", "min_age", "no_more_from", "notes",
     "registration_deadline", "registration_deadline", "required_spoken_language",
     "requirements_en", "requirements_sk", "study_theme_en", "study_theme_sk",
     "title", "to", "type_of_work_en", "type_of_work_sk"]
  end

  # CSV -> CSV, XML -> CSV
  def csvify
    if File.extname(@file) == '.csv'
      @file
    elsif File.extname(@file) == '.xml' # Konvertuj do CSV
      data = Hash.from_xml(File.open(@file))
      # Najdi spravny format XML
      if data.dig('freeplaceslist', 'projects', 'project')
        data = data['freeplaceslist']['projects']['project']
      elsif data.dig('projectform', 'projects', 'project')
        data = data['projectform']['projects']['project']
      else
        raise 'Nastala chyba pri parsovaní xml.'
      end

      # Vytvor CSV pre toto XML
      column_names = data.first.keys
      csv_content = CSV.generate(:col_sep => ";", :force_quotes => true) do |csv|
        csv << column_names
        data.each do |hash|
          hash.each { |_, value| value.to_s.gsub!(';', ',') }
          row = []
          column_names.each do |cname|
            row << hash[cname].to_s # fixne nil -> "", ak v niektorom riadku nie je nieco vyplnene, aby sa cely riadok neposuval
          end
          csv << row
        end
      end
      @file = @file + '.csv'
      File.write(@file, csv_content)
      return @file
    else
      raise 'Nebol vybraný súbor .csv ani .xml.'
    end
  end

  def get_header(file)
    CSV.read(file, :col_sep => ";", headers: true).headers
  end

  # Skús nájsť priradenie (EventColumnSet) stĺpcov DB k stĺpcom súboru
  def get_database_columns_for_file_columns(file)
    header = get_header(file)
    ecs = EventColumnSet.includes(:event_columns).where(event_columns: { their: header }) #.group('event_columns.id').having('count(event_columns.id) = ?', header.size) #.take
    ecs = ecs.reject { |e| e.event_columns.size != header.size }
    if ecs.size > 1
      ecs[1..-1].each { |e| e.destroy }
      ecs = ecs[0]
    end
    [ecs[0], header]
  end

  # Returns hash {my => [their1, their2, ...]}
  def update_event_column_set(filled_params, file)
    my_theirs = {}
    headers = get_header(file)
    @event_column_set = EventColumnSet.where(id: filled_params[:event_column_set_id]).take
    if !@event_column_set.blank?
      headers.each do |header|
        ec = @event_column_set.event_columns.where(their: header).take
        if ec.my != filled_params[header] # Zmenilo sa priradenie, updatuj ho
          ec.update(my: filled_params[header])
        end
        my_theirs[filled_params[header]] ||= []
        my_theirs[filled_params[header]] << header
      end
    else # Predtym neexistovalo, komplet vytvor novy set
      @event_column_set = EventColumnSet.create
      @event_column_set.event_columns.destroy_all
      headers.each do |header|
        EventColumn.create(event_column_set: @event_column_set, my: filled_params[header], their: header)
        my_theirs[filled_params[header]] ||= []
        my_theirs[filled_params[header]] << header
      end
    end
    [@event_column_set, my_theirs, headers]
  end

  def row_identificator(row, event_column_set)
    code = EventColumn.where(event_column_set: event_column_set, my: ['code', 'code_alliance']) # nieco, co v mojej DB je code/code_alliance
    from = EventColumn.where(event_column_set: event_column_set, my: 'from') # nieco, co v mojej db je from
    to = EventColumn.where(event_column_set: event_column_set, my: 'to') # nieco, co v mojej db je to
    result = {}
    result[:errors] = []

    if code.count > 0
      code = code.collect { |one| row[one.their] }.join(' ')
    else
      result[:errors] << I18n.t(:there_is_no_assignment_for_code)
    end

    if from.count == 1
      from = row[from.take.their]
    elsif from.count == 0
      result[:errors] << I18n.t(:there_is_no_assignment_for_start)
    else
      result[:errors] << I18n.t(:there_are_more_choices_for_start)
    end

    if to.count == 1
      to = row[to.take.their]
    elsif to.count == 0
      result[:errors] << I18n.t(:there_is_no_assignment_for_end)
    else
      result[:errors] << I18n.t(:there_are_more_choices_for_end)
    end

    raise result[:errors].uniq.join(", ") if result[:errors].any?
    return { code: code, from: from, to: to }
  end

  # Identifikuj 1 riadok z CSV ako event
  def get_event_by_identificator(row, event_column_set)
    id = row_identificator(row, event_column_set) # Get row code, start, end
    event = Event.where('code=? OR code_alliance=?', id[:code], id[:code])
      .where('`from` LIKE ?', "%#{id[:from]}%").where('`to` LIKE ?', "%#{id[:to]}%")
    if event.count > 1
      raise "V databáze bolo nájdených viac eventov pre kombináciu kód + začiatok + koniec pre: #{[id[:code], id[:from], id[:to]].join(' ')}"
    else
      return { event: event.take, event_identificator: [id[:code], id[:from], id[:to]].join(' ') }
    end
  end

  # Vezmi eventy a rozdel ich na nove, aktualizovane a nezmenene
  # 1. identifikuj riadok - existuje uz v tvojej DB?
  # 2. Ak neexistuje, pridaj ho s danym mapovanim parametrov
  # 3. Ak existuje, skontroluj, ci sa nieco zmenilo. Ak nie -> unchanged
  # 4. Ak sa nieco zmenilo, uloz to.
  def get_event_changes(path, event_column_set, my_theirs)
    new, unchanged, changed, ignored, changes = {}, {}, {}, {}, {}
    CSV.foreach(path, col_sep: ";", headers: true) do |file_row|
      id, event = get_event_by_identificator(file_row, event_column_set).values_at(:event_identificator, :event)
      if event # Existuje taky event, lisia sa jeho data?
        is_changed = false
        is_ignored = false
        event_column_set.event_columns.each do |event_column|
          theirs_col_names = my_theirs[event_column.my] # Toto su len nazvy stlpcov, este spoj hodnoty
          if theirs_col_names
            theirs = theirs_col_names.collect { |their_col| file_row[their_col] }.join(' ')
          else
            theirs = ""
          end
          if event_column.my != 'ignore' && event_column.my != 'code'
            if ['extra_fee', 'event_document', 'event_category', 'notes'].include?(event_column.my) # Teraz ignoruj
            elsif event_column.my == 'no_more_from'
              if theirs.include?('SVK')
                changes[id] << theirs_col_names
                changes[id].flatten!
                ignored[id] = file_row
                is_ignored = true
                break
              end
            else # Porovnaj a podla toho povedz, ci je to ok...
              changes[id] ||= []
              if event.send(event_column.my).is_a?(ActiveSupport::TimeWithZone) && event.send(event_column.my).to_date == Date.parse(theirs) # Datumy sa nezhoduju
              elsif event.send(event_column.my).is_a?(FalseClass) && (theirs == '0' || theirs.blank?)
              elsif event.send(event_column.my).is_a?(TrueClass) && theirs == '1'
              elsif event.send(event_column.my).is_a?(Fixnum) && event.send(event_column.my) == theirs.to_i
              elsif event.send(event_column.my).to_s == theirs # string check
              else
                changes[id] << theirs_col_names
                changes[id].flatten!
                is_changed = true
              end
            end
          end
        end
        changed[id] = file_row if is_changed && !is_ignored
        unchanged[id] = file_row if !is_changed && !is_ignored
      else # Taky event nie je
        new[id] = file_row
      end
    end
    return { new: new, unchanged: unchanged, changed: changed, ignored: ignored, changes: changes }
  rescue Exception => e
    # raise e
    return { errors: [e.message] }
  end

  def make_event_changes(file, event_column_set, make_changes_ids, my_theirs)
    new, changed = [], []
    CSV.foreach(file, col_sep: ";", headers: true) do |file_row|
      id, event = get_event_by_identificator(file_row, event_column_set).values_at(:event_identificator, :event)
      if id && make_changes_ids.include?(id)
        if !file_row['no_more_from'].nil? && file_row['no_more_from'].include?('SVK') # Ignoruj row
        else
          if event
            ewc = event_with_changes(file_row, event_column_set, my_theirs, event)
            changed << ewc if !ewc[:changes].blank?
          else
            ewc = event_with_changes(file_row, event_column_set, my_theirs)
            new << ewc if !ewc.blank?
          end
        end
      end
    end
    File.delete(file) # TODO
    return { new: new, changed: changed }
  rescue Exception => e
    # raise e
    return { errors: [e.message] }
  end

  # Buď vezme konkrétny event a nastaví mu parametre, alebo vytvorí nový
  # Asi by neskor sla pouzit metoda event.attributes = {title: 'Nase mesto - Integra', ...}; event.save
  # TODO set event type id!
  def event_with_changes(row, event_column_set, my_theirs, event = Event.new(event_type_id: EventType.first.id))
    changes = {}
    is_changed = false
    changes["notes"] ||= ""
    changes["notes"] += "Import " + DateTime.now.strftime("%d.%m.%Y %H:%M") + " | "
    extra_fee, documents, ccategories = [], [], []
    event_column_set.event_columns.each do |event_column|
      theirs_cols = my_theirs[event_column.my] # Toto su len nazvy stlpcov, este spoj hodnoty
      if theirs_cols
        theirs = theirs_cols.collect { |their_col|
          if event_column.my == 'event_category'
            if row[their_col] == "1" || row[their_col] == "true"
              their_col
            else
              row[their_col]
            end
          else
            row[their_col]
          end
        }.uniq.join(' ')
      else
        theirs = ""
      end
      if event_column.my != 'ignore' && !theirs.blank? && event_column.my != 'no_more_from'
        if event_column.my == 'extra_fee'
          if !event.extra_fees.find_by_name(theirs)
            extra_fee << event.extra_fees.new(name: theirs)
          end
        elsif event_column.my == 'event_document'
          if !event.event_documents.find_by_title(theirs)
            documents << event.event_documents.new(title: theirs)
          end
        elsif event_column.my == 'event_category' # TODO Skus preliezt EventCategories a najst, inak pridat do notes
          ecategories = event.event_categories.pluck('event_categories.id')
          categories = []
          category_names = theirs.split(',').collect { |c| c.strip }
          category_names.each do |category|
            e1 = EventCategory.where("name = ? OR abbr = ?", category, category).pluck(:id)
            e2 = EventCategorySci.where(name: category).pluck(:event_category_id)
            e3 = EventCategoryAlliance.where(name: category).pluck(:event_category_id)
            joined = (e1 + e2 + e3).uniq
            if joined.blank?
              changes["notes"] += "Unknown type " + category + " | "
            else
              categories += joined
            end
          end
          categories.uniq!
          if categories.any?
            (categories - ecategories).each do |c|
              ccategories << event.event_with_categories.new(event_category_id: c)
            end
          end
        elsif event_column.my == 'notes' # TODO Davaj tam stlpec:hodnota\n
          changes["notes"] += "Notes " + theirs + " | "
        else # Porovnaj a podla toho povedz, ci je to ok...
          if event.send(event_column.my).is_a?(ActiveSupport::TimeWithZone) && event.send(event_column.my).to_date == Date.parse(theirs) # OK! Datumy sa zhoduju
          elsif event.send(event_column.my).is_a?(FalseClass) && (theirs == '0' || theirs.blank?)
          elsif event.send(event_column.my).is_a?(TrueClass) && theirs == '1'
          elsif event.send(event_column.my).is_a?(Fixnum) && event.send(event_column.my) == theirs.to_i
          elsif event.send(event_column.my).to_s == theirs # string check
          else
            is_changed = true
            changes[event_column.my] = theirs
          end
        end
      end
    end
    event.attributes = changes
    event.title = "No title" if event.title.blank?
    if !is_changed
      if extra_fee.any?
        changes['extra_fee'] = "changed"
        extra_fee.each { |e| e.save } if event.try(:id)
      end
      if documents.any?
        changes['event_document'] = "changed"
        documents.each { |e| e.save } if event.try(:id)
      end
      if ccategories.any?
        changes['event_category'] = "changed"
        ccategories.each { |e| e.save } if event.try(:id)
      end
      return { event: event, changes: changes }
    elsif event.save(validate: false)
      if extra_fee.any?
        changes['extra_fee'] = "changed"
        extra_fee.each { |e| e.save }
      end
      if documents.any?
        changes['event_document'] = "changed"
        documents.each { |e| e.save }
      end
      if ccategories.any?
        changes['event_category'] = "changed"
        ccategories.each { |e| e.save }
      end
      return { event: event, changes: changes }
    else
      return { event: event, changes: changes, errors: event.errors }
    end
  end

end