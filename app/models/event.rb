class Event < ActiveRecord::Base
  belongs_to :organization
  belongs_to :event_type

  has_many :event_with_categories, dependent: :destroy
  has_many :event_categories, through: :event_with_categories

  has_many :extra_fees, dependent: :destroy
  accepts_nested_attributes_for :extra_fees, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }

  has_many :event_documents, dependent: :destroy
  accepts_nested_attributes_for :event_documents, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['title'].blank? }


  has_many :event_in_lists, dependent: :destroy
  has_many :event_lists, through: :event_in_lists

  has_many :volunteers
  has_many :trainers
  has_many :local_partners
  has_many :leaders

  validates_presence_of :title, message: I18n.t(:title_have_to_be_filled)
  validates :capacity_men, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :capacity_women, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :capacity_total, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :free_men, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :free_women, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :free_total, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:capacity_have_to_be_at_least_zero) }
  validates :min_age, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:age_should_be_at_least_zero) }
  validates :max_age, numericality: {
    greater_than_or_equal_to: 0, message: I18n.t(:age_should_be_at_least_zero) }
  validate :capacity_free_total_are_sum

  # Kontroluje, že total kapacita je súčtom ženy + muži
  def capacity_free_total_are_sum
    if ignore_sex_for_capacity != true
      if capacity_total != capacity_men + capacity_women
        errors.add(:capacity_total, I18n.t(:total_capacity_should_be_sum_of_men_and_women))
      end
      if free_total != free_men + free_women
        errors.add(:free_total, "Free places #{I18n.t(:total_capacity_should_be_sum_of_men_and_women).downcase}")
      end
    end
  end

  def from_to
    if !from.blank? && !to.blank? # from, to
      return "#{from.strftime("%d.%m.")} - #{to.strftime("%d.%m.%Y")}" if is_only_date
      return "#{from.strftime("%d.%m.%Y")} #{from.strftime("%H:%M")} - #{to.strftime("%d.%m.%Y")} #{to.strftime("%H:%M")}"
    end
    if !from.blank? # from
      return "#{from.strftime("%d.%m.%Y")}" if is_only_date
      return "#{from.strftime("%d.%m.%Y")} #{from.strftime("%H:%M")}"
    end
    if !to.blank? # to
      return "#{to.strftime("%d.%m.%Y")}" if is_only_date
      return "#{to.strftime("%d.%m.%Y")} #{to.strftime("%H:%M")}"
    end
    "" # nothing
  end

  # title for selected language
  def translated_title
    if I18n.locale == :en && !title_en.blank?
      title_en
    else
      title # mandatory attribute, is not blank in most cases
    end
  end

  # Pre kalendár
  def start_time
    self.from #.to_date # is an attribute of type 'Date' accessible through MyModel's relationship
  end

  def can_be_added_to_bag(current_user)
    if is_cancelled || !is_published || capacity_total == 0 || free_total == 0 ||
      (registration_deadline && registration_deadline < DateTime.now)
      false
    else
      if ignore_sex_for_capacity != true
        if current_user && ((current_user.sex == 'M' && (capacity_men == 0 || free_men == 0)) ||
          ((current_user.sex == 'Ž' || current_user.sex == 'W') && (capacity_women == 0 || free_women == 0)) ||
          (current_user.age && (current_user.age < min_age || current_user.age > max_age)))
          false
        else
          true
        end
      else
        if current_user && current_user.age && (current_user.age < min_age || current_user.age > max_age)
          false
        else
          true
        end
      end
    end
  end

  def can_be_registered(current_user)
    if can_be_added_to_bag(current_user)
      true
    else
      false
    end
  end

  # GPS treba refreshnut, ak je v tomto evente prazdne alebo parametre formulara su prazdne (sme vymazali)
  # A zaroven ak je vyplnena adresa a/alebo mesto a/alebo stat
  def gps_needs_to_be_refreshed?(param_lat, param_lon)
    is_not_filled_gps = (param_lat.blank? && param_lon.blank?)
    is_filled_address = (!address.blank? || !city.blank? || !country.blank?)
    if is_not_filled_gps && is_filled_address
      true
    else
      false
    end
  end

  require 'csv'

  def self.my_columns
    %w(employee title from to code code_alliance country city address gps_latitude gps_longitude
      notes airport bus_train capacity_men capacity_women capacity_total free_men
      free_women free_total min_age max_age fees_sk fees_en registration_deadline
      registration_deadline can_create_member_registration is_cancelled
      required_spoken_language introduction_sk type_of_work_sk study_theme_sk
      accomodation_sk camp_advert_sk language_description_sk requirements_sk
      location_sk additional_camp_notes_sk introduction_en type_of_work_en
      study_theme_en accomodation_en camp_advert_en language_description_en
      requirements_en location_en additional_camp_notes_en ignore event_category
      event_document extra_fee no_more_from ignore_sex_for_capacity).sort
  end

  # Krok 1: Skús priradiť stĺpce, ktoré vieš - ak niektorý nevieš, opýtaj sa
  def self.process_csv_1(path)
    ecs = nil
    header = []
    # Kontrola 1: Header zo suboru je v event column sete
    CSV.foreach(path, :col_sep => ";") do |row|
      header = row.collect { |x| x.to_s }
      ecs = EventColumnSet.includes(:event_columns).where(event_columns: { their: header })
      break
    end
    # Kontrola 2: header zo suboru obsahuje prave to, co event column set (nic viac, nic menej)
    sizeok = []
    ecs.each do |e|
      sizeok << e.id if e.event_columns.size == header.size
    end
    # Nechaj si jeden a ostatne destroy (naco ti je viac rovnakych)
    if sizeok.count > 1
      EventColumnSet.where(id: sizeok[1..-1]).destroy_all
      sizeok = [sizeok[0]]
    end
    [EventColumnSet.includes(:event_columns).where(id: sizeok), header]
  end

  # Get header from csv file
  def self.get_csv_header(path, sorted = true)
    CSV.foreach(path, :col_sep => ";") do |row|
      if sorted
        return row.collect { |x| x.to_s }.sort
      else
        return row
      end
    end
  end

  def self.row_identificator(row, event_column_set)
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

    return result if result[:errors].any?
    return { code: code, from: from, to: to }
  end

  # Identifikuj 1 riadok z CSV ako event
  def self.identify_event(row, event_column_set)
    id = row_identificator(row, event_column_set) # Get row code, start, end
    return id if !id[:errors].blank?
    event = Event.where('code=? OR code_alliance=?', id[:code], id[:code])
      .where('`from` LIKE ?', "%#{id[:from]}%")
      .where('`to` LIKE ?', "%#{id[:to]}%").take # TODO ? Co ak takych je viac?
    return { event: event, event_identificator: [id[:code], id[:from], id[:to]].join(' ') }
  end

  # Vezmi eventy a rozdel ich na nove, aktualizovane a nezmenene
  # 1. identifikuj riadok - existuje uz v tvojej DB?
  # 2. Ak neexistuje, pridaj ho s danym mapovanim parametrov
  # 3. Ak existuje, skontroluj, ci sa nieco zmenilo. Ak nie -> unchanged
  # 4. Ak sa nieco zmenilo, uloz to.
  def self.process_csv_2(path, event_column_set, my_theirs)
    new = {}
    unchanged = {}
    changed = {}
    errors = []
    CSV.foreach(path, col_sep: ";", headers: true) do |row|
      identified_event = Event.identify_event(row, event_column_set) # identifikuj konkretny event = datumy + kod
      return identified_event if !identified_event[:errors].blank?
      id = identified_event[:event_identificator]
      event = identified_event[:event]
      if event # Existuje taky event
        if !row['no_more_from'].nil? && row['no_more_from'].include?('SVK') # Pokracuj na dalsi riadok, ignoruj tento uplne
          unchanged[id] = row
        else
          is_changed = false
          event_column_set.event_columns.each do |event_column|
            theirs_cols = my_theirs[event_column.my] # Toto su len nazvy stlpcov, este spoj hodnoty
            theirs = theirs_cols.collect { |their_col| row[their_col] }.join(' ')
            if event_column.my != 'ignore' && event_column.my != 'code' && !theirs.blank? && event_column.my != 'no_more_from'
              if event_column.my == 'extra_fee' # TODO pastni do notes?
              elsif event_column.my == 'event_document' # TODO pastni do notes?
              elsif event_column.my == 'event_category' # TODO pastni do notes?
              elsif event_column.my == 'notes' # TODO Davaj tam stlpec:hodnota\n
              else # Porovnaj a podla toho povedz, ci je to ok...
                if event.send(event_column.my).is_a?(ActiveSupport::TimeWithZone) && event.send(event_column.my).to_date == Date.parse(theirs) # OK! Datumy sa zhoduju
                elsif event.send(event_column.my).is_a?(FalseClass) && (theirs == '0' || theirs.blank?)
                elsif event.send(event_column.my).is_a?(TrueClass) && theirs == '1'
                elsif event.send(event_column.my).is_a?(Fixnum) && event.send(event_column.my) == theirs.to_i
                elsif event.send(event_column.my).to_s == theirs # string check
                else
                  is_changed = true
                end
              end
            end
          end
          changed[id] = row if is_changed
          unchanged[id] = row if !is_changed
        end
      else # Taky event nie je
        new[id] = row
      end
    end
    return { new: new, unchanged: unchanged, changed: changed, ok_errors: errors }
  rescue CSV::MalformedCSVError => e
    return { errors: [e.message] }
  end

  def self.process_csv_3(path, event_column_set, params, my_theirs)
    new = []
    changed = []
    CSV.foreach(path, col_sep: ";", headers: true) do |row|
      identified_event = Event.identify_event(row, event_column_set) # identifikuj konkretny event = datumy + kod
      return identified_event if !identified_event[:errors].blank?
      id = identified_event[:event_identificator]
      event = identified_event[:event]
      if id && params.include?(id)
        if !row['no_more_from'].nil? && row['no_more_from'].include?('SVK') # Ignoruj row
        else
          if event
            ewc = event_with_changes(row, event_column_set, my_theirs, event)
            changed << ewc if !ewc.blank?
          else
            ewc = event_with_changes(row, event_column_set, my_theirs)
            new << ewc if !ewc.blank?
          end
        end
      end
    end
    return { new: new, changed: changed }
  rescue CSV::MalformedCSVError => e
    return { errors: [e.message] }
  rescue ActiveRecord::StatementInvalid => e
    return { errors: [e.message] }
  end

  # Buď vezme konkrétny event a nastaví mu parametre, alebo vytvorí nový
  # Asi by neskor sla pouzit metoda event.attributes = {title: 'Nase mesto - Integra', ...}; event.save
  # TODO set event type id!
  def self.event_with_changes(row, event_column_set, my_theirs, event = Event.new(event_type_id: EventType.first.id))
    changes = {}
    is_changed = false
    changes["notes"] ||= ""
    changes["notes"] += "Import " + DateTime.now.strftime("%d.%m.%Y %H:%M") + " | "
    event_column_set.event_columns.each do |event_column|
      theirs_cols = my_theirs[event_column.my] # Toto su len nazvy stlpcov, este spoj hodnoty
      theirs = theirs_cols.collect { |their_col|
        if event_column.my == 'event_category'
          if row[their_col] == "1" || row[their_col] == "true"
            their_col
          end
        else
          row[their_col]
        end
      }.uniq.join(' ')
      if event_column.my != 'ignore' && !theirs.blank? && event_column.my != 'no_more_from'
        if event_column.my == 'extra_fee' # TODO pastni do notes?
          changes["notes"] += "Extra Fees: " + theirs + " | "
        elsif event_column.my == 'event_document' # TODO pastni do notes?
          changes["notes"] += "Documents: " + theirs + " | "
        elsif event_column.my == 'event_category' # TODO Skus preliezt EventCategories a najst, inak pridat do notes
          changes["notes"] += "Categories: " + theirs + " | "
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
    if !is_changed
      return nil
    elsif event.save(validate: false)
      return { event: event, changes: changes }
    else
      return { event: event, changes: changes, errors: event.errors }
    end
  end

end
