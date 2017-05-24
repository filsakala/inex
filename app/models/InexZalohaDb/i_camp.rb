class ICamp < DatabaseTransformator
  self.table_name = "i_camp"
  # Ignore:
  # OK: _title, _title__en, _description, _description__en, _capacity (spolu), _volunteers (toto je asi obsadene?),
  # _code, _place, _duration (from - to), _age_limit (18+/18-26)
  # Local partner TODO: _contact_fullname, _contact_email, _contact_phone
  # Event type su tabory na Slovensku
  has_many :i_chief2camps, :foreign_key => '_camp_id'
  has_many :i_cheifs, through: :i_chief2camps

  def self.transform
    event_type = EventType.where(title: 'Zo zálohy: Tábory na Slovensku').take
    if !event_type
      set = SuperEventType.where(name: 'Dobrovoľnícke').take
      set = SuperEventType.create(name: 'Dobrovoľnícke') if !set
      event_type = EventType.create(title: 'Zo zálohy: Tábory na Slovensku', super_event_type_id: set.id)
    end
    ICamp.all.each do |i|
      from, to = i._duration.split(' - ')
      age_from = 0
      age_to = 100
      if i._age_limit == "18+"
        age_from = 18
        age_to = 100
      else
        age_from, age_to = i._age_limit.split('-')
      end
      cmen = i._capacity / 2
      cwomen = i._capacity - cmen
      event = Event.new(event_type_id: event_type.id,
                        title: i._title, title_en: i._title__en,
                        from: from, to: to, is_only_date: true,
                        introduction_sk: i._description, introduction_en: i._description__en,
                        capacity_total: i._capacity, capacity_men: cmen, capacity_women: cwomen, free_total: 0,
                        city: i._place, country: 'Slovakia', code: i._code, min_age: age_from, max_age: age_to
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
      if event.save # Save chiefs via chief2camp
        self.create_chiefs(i, event)
      else
        error_message = ""
        if event.errors.any?
          error_message = event.errors.full_messages.join(', ')
        end
        LogActivity.create(action: "Transformation: Camp -> Event", what: "Error, message: #{error_message}")
      end
    end
  end

  def self.create_chiefs(i, event)
    # Find local partner from _contact_fullname, _contact_phone, _contact_email
    lpname, lpsurname = i._contact_fullname.split(' ')
    cheifs_names = i.i_cheifs.where(_name: lpname).where(_surname: lpsurname)
    if !cheifs_names.any? # vytvor aj lokalneho partnera pre tento event z tychto dat
      user = User.where(name: lpname).where(surname: lpsurname)
      if !user.any?
        user = User.new(name: lpname, surname: lpsurname, login_mail: i._contact_email, personal_phone: i._contact_phone)
        user.password = user.password_confirmation = "Very4Secret8Password1After3Database7Reset"
        user.save
        event.local_partners.create(user: user)
      else
        event.local_partners.create(user: user.take)
      end
    end
    # All other chiefs in i_chiefs table
    i.i_cheifs.each do |c|
      user = User.where(name: c._name).where(surname: c._surname.downcase.capitalize)
      user = User.where(login_mail: c._email) if !user.any? # try also join via email
      if c._surname == "CHABANOVÁ" # Ma 2x user konto -> FIX
        user = user.where(login_mail: 'bchabanova@gmail.com')
        fix = user.take
        fix.perform_password_validation = false
        fix.update(birth_date: Date.parse("19.12.1997"))
      end
      if user.count == 0 # User will be created from i_chief data
        self.create_user_from_chief_data(c)
      elsif user.count > 1
        LogActivity.create(action: "Transformation: Camp -> Event, Cheif -> User", what: "Error, message: More than one user for #{c._name} #{c._surname}")
      else # only one user -> OK
        user = user.take
        if c._chief_role_id == 1 # Leader
          event.leaders.create(user: user)
        elsif c._chief_role_id == 2 # Local partner
          event.local_partners.create(user: user)
        else
          LogActivity.create(action: "Transformation: Camp -> Event, Cheif -> User", what: "Error, message: Unknown chief role id: #{c._chief_role_id}")
        end
      end
    end
  end

  def self.create_user_from_chief_data(c)
    occupation = { "1": 'Student', "2": 'Unemployed', "3": 'Employed' }[:"#{c._chief_job_id}"]
    occupation ||= 'Other'
    user = User.new(
      name: c._name, surname: c._surname, birth_date: c._birthdate,
      place_of_birth: c._birthplace, state: 'active', login_mail: c._email,
      personal_phone: c._phone, occupation: occupation
    )
    user.password = user.password_confirmation = "Very4Secret8Password1After3Database7Reset"
    if user.save
      user.addresses.create(
        title: "Permanent",
        address: c._street,
        postal_code: c._postalcode,
        city: c._city
      )
    else
      message = user.errors.full_messages.join(', ') + ", data:" + user.inspect if user.errors.any?
      message ||= ""
      LogActivity.create(action: "Transformation: Camp -> Event, Cheif -> User", what: "Error, message: #{message}")
    end
  end
end