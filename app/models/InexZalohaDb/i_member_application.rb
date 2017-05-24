class IMemberApplication < DatabaseTransformator
  self.table_name = "i_member_application"
  # Proste prihlaska za clena. Vies, co s tym mas robit...
  # OK: createdtime, updatedtime (toto musis kvoli vypoctu clenstva v roku),
  # _street, _postalcode, _city, _district, _region, _actual_street, _actual_postalcode, _actual_city, _actual_region,
  # _note, _sex (1=men/2=women), _user_id

  # K tomuto este prirad platbu z _i_payment_info
  has_one :i_payment_info, -> { where(parentclass: "member_application") }, :foreign_key => 'parentid'
  belongs_to :country, class: ICodeCountry, foreign_key: '_country_id'

  def self.transform
    # get event
    event_type = EventType.where(title: "Prihlášky za člena").take
    event = event_type.events.take
    event ||= event_type.events.create(title: 'Prihláška za člena')

    IMemberApplication.all.each do |i|
      sex = { "1": "M", "2": "W" }[:"#{i._sex.to_s}"]
      user = User.where(name: i._name).where(surname: i._surname)
      user = User.where(login_mail: i._email) if user.count == 0
      user = user.where(login_mail: i._email) if user.count > 1
      if user.count == 0
        LogActivity.create(action: "Transformation: IMemberApplication -> EventList", what: "Error, message: No user for #{i._name} #{i._surname}")
      elsif user.count > 1
        LogActivity.create(action: "Transformation: IMemberApplication -> EventList", what: "Error, message: More than one user for #{i._name} #{i._surname}")
      else
        event_list = EventList.new(
          state: "closed", name: i._name, surname: i._surname,
          birth_date: i._birthdate, place_of_birth: i._birth_place, sex: sex,
          created_at: DateTime.strptime(i.createdtime.to_s, '%s'),
          updated_at: DateTime.strptime(i.modifiedtime.to_s, '%s'),
          personal_phone: self.fix_phone_number(i._phone), personal_mail: i._email,
          user_id: user.take.id, nationality: user.take.nationality
        )
        event_list.check_conditions_agreement = false

        if event_list.save # Create address and add event to event list + payment
          event_list.event_in_lists.create(event_id: event.id)
          event_list.addresses.create(
            title: "Permanent", address: i._street, postal_code: i._postalcode,
            city: i._city, country: i.country.try(:_title_en)
          )
          if !i.i_payment_info.blank? && i.i_payment_info._type != 4 # 4 = žiadna platba
            my_ptype = ["", 'Prevodom', 'Hotovosť', 'Pošta', 'Žiadna platba'][i.i_payment_info._type]
            # raise my_ptype.inspect
            p = event_list.participation_fees.create(
              user_id: user.take.id,
              amount: i.i_payment_info._price, pay_type: my_ptype, date: Date.parse(i.i_payment_info._paid_at),
              notes: "vs: #{i.i_payment_info._vs}",
              created_at: DateTime.strptime(i.i_payment_info.createdtime.to_s, '%s'),
              updated_at: DateTime.strptime(i.i_payment_info.modifiedtime.to_s, '%s'),
            )
            # if !p.save
            #   LogActivity.create(action: "Transformation: IMemberApplication -> EventList, IPaymentInfo -> ParticipationFee", what: "Error, message: #{p.errors.full_messages.join(', ')}")
            # end
          end
        else
          LogActivity.create(action: "Transformation: IMemberApplication -> EventList", what: "Error, message: #{event_list.errors.full_messages.join(', ')}, phone number: #{i._phone}")
        end
      end
    end
  end

  # Format: +421 905 501 078
  def self.fix_phone_number(number)
    number = number.strip
    if !number.blank? && !/^\+([[:digit:]]{1,3}[[:blank:]]){3,}[[:digit:]]{1,3}$/.match(number.strip) # error
      number = number.gsub(/\s+/, "") # Remove whitespaces
      if number[0] == 0 # Nie je vo formate +421 ...
        if number[1] == 0 # 00421 ... ?
          "+#{number[2..4]} #{number[5..7]} #{number[8..10]} #{number[11..13]}"
        end
      elsif number.length == 13 # Malo by byt OK, len nema medzery
        "#{number[0..3]} #{number[4..6]} #{number[7..9]} #{number[10..12]}"
      elsif number == "+421"
        "+421 000 000 000"
      else # error, ale zatial vrat to cislo
        number
      end
      case number
        when "+4407926224548"
          "+44 792 622 454 8"
        when "0420721568146"
          "+420 721 568 146"
        when "0420721568146"
          "+420 721 568 146"
        when "00421908829729"
          "+421 908 829 729"
        when "oo4369910661221"
          "+436 991 066 122 1"
        when "+4210902583190"
          "+421 902 583 190"
        when "00353862176950"
          "+353 862 176 950"
        when "0032488972170"
          "+324 889 721 70"
        when "0032483598975"
          "+324 835 989 75"
        when "0032483598975"
          "+324 835 989 75"
        when "+421 18229638"
          "+421 918 229 638"
        when "+421 0904 371 302"
          "+421 904 371 302"
        when "+42191548374"
          "+421 915 483 74"
        when "+48615658123760"
          "+486 156 581 237 60"
      end
    else # OK
      number
    end
  end
end