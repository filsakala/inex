class ICourseApp < DatabaseTransformator
  self.table_name = "i_course_app"
  # OK: _first_name, _last_name, _birthdate, _birthplace, _nationality, _occupation (toto vyzera ako ID)
  # _phone, _email, _male (0/1), _female (0/1)
  # _ec_name, _ec_phone, _ec_email,
  # _actual_street, _actual_postalcode, _actual_city, _actual_region, _actual_country
  # _street, _postalcode, _city, _region, _country (ID)
  # _vegetarian (0/1), _transport (0/1), _rem_general, _rem_health, _why_part_vol
  # _user_id (i_user.id), _want_member (a s tymto co? :D)
  has_one :i_payment_info, -> { where(parentclass: "course_app") }, :foreign_key => 'parentid'
  has_many :i_vef_project_choices, -> { where(parentclass: "course_app") }, :foreign_key => 'parentid'
  has_many :i_workcamps, through: :i_vef_project_choices
  belongs_to :country, class: ICodeCountry, foreign_key: '_country_id'

  def self.transform
    ICourseApp.all.each do |i|
      sex_num = ((i._male ? 1 : 0) + (i._female ? 1 : 0)* 2)
      sex = { "1": "M", "2": "W" }[:"#{sex_num.to_s}"]
      user = User.where(name: i._first_name).where(surname: i._last_name)
      user = User.where(login_mail: i._email) if user.count == 0
      user = user.where(login_mail: i._email) if user.count > 1
      occupation = { "1": 'Student', "2": 'Unemployed', "3": 'Employed' }[:"#{i._occupation.to_s}"]
      occupation ||= 'Other'
      if user.count == 0
        LogActivity.create(action: "Transformation: IMemberApplication -> EventList", what: "Error, message: No user for #{i._first_name} #{i._last_name}")
      elsif user.count > 1
        LogActivity.create(action: "Transformation: IMemberApplication -> EventList", what: "Error, message: More than one user for #{i._first_name} #{i._last_name}")
      else
        event_list = EventList.new(
          state: "closed", name: i._first_name, surname: i._last_name,
          birth_date: i._birthdate, place_of_birth: i._birthplace, sex: sex,
          created_at: DateTime.strptime(i.createdtime.to_s, '%s'),
          updated_at: DateTime.strptime(i.modifiedtime.to_s, '%s'),
          personal_phone: self.fix_phone_number(i._phone.strip), personal_mail: i._email,
          user_id: user.take.id, nationality: i._nationality, occupation: occupation,
          emergency_phone: self.fix_phone_number(i._ec_phone), emergency_name: i._ec_name, emergency_mail: i._email,
          why: i._why_part_vol, remarks: "#{i._rem_general}, Vegetarian: #{i._vegetarian}, Transport: #{i._transport}", on_health: i._rem_health
        )
        event_list.check_conditions_agreement = false

        if event_list.save # Create address, payment, events in list and volunteer
          i.i_workcamps.each do |w|
            # find event
            # event = Event.where(title: w._title)
            # event = event.where(from: Date.strptime(w._start_date, "%d.%m.%Y")) if event.count > 1 && !w._start_date.blank? # FIX
            # event = event.where(code: "NICE-17-044") if event.count > 1 && w._title == "Shirakami 1 (Aomori)" # FIX
            event = Event.where(notes: w.id.to_s)
            if event.count != 1
              LogActivity.create(action: "Transformation: IMemberApplication -> EventList, Event->EventInList", what: "Error, message: #{event.count} #{w._title} to add to list, should be 1.")
            else
              event_list.event_in_lists.create(event_id: event.take.id)
              Volunteer.create(event_list: event_list, event: event.take)
            end
          end
          event_list.addresses.create(
            title: "Permanent", address: i._street, postal_code: i._postalcode,
            city: i._city, country: i.country.try(:_title_en)
          )
          event_list.addresses.create(
            title: "Actual", address: i._actual_street, postal_code: i._actual_postalcode,
            city: i._actual_city, country: ICodeCountry.find(i._actual_country).try(:_title_en)
          )
          if !i.i_payment_info.blank? && i.i_payment_info._type != 4 # 4 = žiadna platba
            my_ptype = ["", 'Prevodom', 'Hotovosť', 'Pošta', 'Žiadna platba'][i.i_payment_info._type]
            p = event_list.participation_fees.create(
              user_id: user.take.id,
              amount: i.i_payment_info._price, pay_type: my_ptype, date: Date.parse(i.i_payment_info._paid_at),
              notes: "vs: #{i.i_payment_info._vs}",
              created_at: DateTime.strptime(i.i_payment_info.createdtime.to_s, '%s'),
              updated_at: DateTime.strptime(i.i_payment_info.modifiedtime.to_s, '%s'),
            )
          end
        else
          LogActivity.create(action: "Transformation: IVefReg -> EventList", what: "Error, message: #{event_list.errors.full_messages.join(', ')}, phone number: #{i._phone}, fix: #{self.fix_phone_number i._phone}, em number: #{i._ec_phone}, fix: #{self.fix_phone_number i._ec_phone}")
        end
      end
    end
  end

  # Format: +421 905 501 078
  def self.fix_phone_number(number)
    number = number.strip
    if !number.blank? && !/^\+([[:digit:]]{1,3}[[:blank:]]){3,}[[:digit:]]{1,3}$/.match(number.strip) # error
      number = number.gsub(/\s+/, "") # Remove whitespaces
      if number[0] == "0" # Nie je vo formate +421 ...
        if number[1] == "0" # 00421 ... ?
          return "+#{number[2..4]} #{number[5..7]} #{number[8..10]} #{number[11..13]}"
        elsif number.length == 10 # 0900 000 000
          return "+421 #{number[1..3]} #{number[4..6]} #{number[7..9]}"
        end
      elsif number.length == 13 # Malo by byt OK, len nema medzery
        return "#{number[0..3]} #{number[4..6]} #{number[7..9]} #{number[10..12]}"
      elsif number == "+421"
        return "+421 000 000 000"
      else # error, ale zatial vrat to cislo
        number
      end
      case number
        when "-"
          "+421 000 000 000"
        when "944957480"
          "+421 944 957 480"
        when "....."
          "+421 000 000 000"
        when "+421949148842_"
          "+421 949 148 842"
        when "+31622947833"
          "+316 229 478 33"
        when "+40720163705"
          "+407 201 637 05"
        when "+33672518397"
          "+336 725 183 97"
        when "+421 4594545"
          "+421 4 594 545"
      end
    else # OK
      return number
    end
  end

  def self.any_payment
    ICourseApp.all.each do |i|
      if i.i_payment_info && i.i_payment_info._price > 0
        return i
      end
    end
  end
end