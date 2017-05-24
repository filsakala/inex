class IUser < DatabaseTransformator
  self.table_name = "i_user"
  # ok: _name, _surname, _birthdate, _sex (1=men, 2=women), _password,
  # _birth_place, _nationality, _email, _phone, _note
  # _street, _postalcode, _city, _district, _region, _country_id, _district_id
  #
  # Ignore: _want_member (0/1), _member (0/1), _actual_street, _actual_postalcode,
  # _actual_city, _actual_district, _actual_region, _actual_country_id,
  # _actual_district_id, _actual_residence (0/1)
  # _occupation: 1 = Student, 2=Employed, 3='Unemployed', 4='Other'
  # Vsetci tito nebudu mat priradenu rolu, budu aktivni
  belongs_to :country, class: ICodeCountry, foreign_key: '_country_id'
  belongs_to :actual_country, class: ICodeCountry, foreign_key: '_actual_country_id'

  def self.transform
    IUser.all.each do |i|
      sex = { "1": "M", "2": "W" }[:"#{i._sex.to_s}"]
      occupation = { "1": 'Student', "2": 'Employed', "3": 'Unemployed', "4": 'Other' }[:"#{i._occupation}"]
      occupation ||= 'Other'
      LogActivity.create(action: "Transformation: User -> User", what: "Error: Unknown sex: #{i._sex}") if sex.blank? && !i._sex.blank?
      user = User.new(
        name: i._name,
        surname: i._surname,
        birth_date: i._birthdate,
        place_of_birth: i._birth_place,
        sex: sex,
        # password_digest: i._password, # :(
        state: 'active',
        nationality: i._nationality,
        login_mail: i._email,
        personal_phone: i._phone,
        other_contacts: i._note,
        occupation: occupation
      )
      # user.perform_password_validation = false
      user.password = user.password_confirmation = "Very4Secret8Password1After3Database7Reset"
      if user.save
        user.addresses.create(
          title: "Permanent",
          address: i._street,
          postal_code: i._postalcode,
          city: i._city,
          country: i.country.try(:_title_en)
        )
        user.addresses.create(
          title: "Actual",
          address: i._actual_street,
          postal_code: i._actual_postalcode,
          city: i._actual_city,
          country: i.actual_country.try(:_title_en)
        )
        # LogActivity.create(action: "Transformation: User -> User", what: "Success id #{user.id}")
      else
        message = user.errors.full_messages.join(', ') + ", data:" + user.inspect if user.errors.any?
        message ||= ""
        LogActivity.create(action: "Transformation: User -> User", what: "Error: #{message}")
      end
    end
  end
end