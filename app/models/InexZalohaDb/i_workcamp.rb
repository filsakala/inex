class IWorkcamp < DatabaseTransformator
  self.table_name = "i_workcamp"
  # ok: _title, _title__en, _code, _work, _start_date, _end_date, _location, _country,
  # _region, _languages, _extrafee, _extrafee_currency, _min_age, _max_age, _disabled_vols,
  # _numvol, _vegetarian, _family, _description, _description_en, _airport, _train_station,
  # _numvol_m, _numvol_f, _max_vols_per_country, _max_teenagers, _max_national_vols,
  # _notes, _notes__en, _organization, _country_id, _workcodes (V speci tvare, preco nie :D #ENVI#RENO#STUDY#)
  # _active, _special, _max_man, _max_woman, _price, _contact_fullname, _contact_phone,
  # _contact_email, _male_free, _female_free, _participation_fee_curr, _participation_fee,
  # _accesibility, _svk, _intranet
  # Event type su tabory na Slovensku
  has_many :i_chief2workcamps, :foreign_key => '_workcamp_id'
  has_many :i_cheifs, through: :i_chief2workcamps
  belongs_to :country, class: ICodeCountry, foreign_key: '_country_id'

  def self.transform
    event_type = EventType.where(title: 'Zo zálohy: Workcampy').take
    if !event_type
      set = SuperEventType.where(name: 'Dobrovoľnícke').take
      set = SuperEventType.create(name: 'Dobrovoľnícke') if !set
      event_type = EventType.create(title: 'Zo zálohy: Workcampy', super_event_type_id: set.id)
    end
    wrong_orgs = []
    IWorkcamp.all.each do |i|
      i._numvol_m = 0 if i._numvol_m < 0
      i._numvol_f = 0 if i._numvol_f < 0
      i._numvol = i._numvol_m + i._numvol_f
      country = i.country.try(:title_en)
      country ||= i._country
      i._organization = self.organization_fix(i._organization.strip) # Fixne inak napisane existujuce nazvy org.
      organization = Organization.where(name: i._organization).take
      if !organization
        wrong_orgs << i._organization
        # LogActivity.create(action: "Transformation: Workcamp -> Event", what: "Error, organization #{i._organization} not found.")
      end
      event = Event.new(event_type_id: event_type.id,
                        title: i._title, title_en: i._title__en,
                        from: i._start_date.try(:to_date), to: i._end_date.try(:to_date), is_only_date: true,
                        code: i._code, min_age: i._min_age, max_age: i._max_age, city: i._location,
                        bus_train: i._train_station, airport: i._airport,
                        free_total: i._numvol,
                        free_men: i._numvol_m, free_women: i._numvol_f, capacity_total: i._numvol,
                        capacity_men: i._numvol_m, capacity_women: i._numvol_f,
                        introduction_sk: i._description, introduction_en: i._description__en,
                        additional_camp_notes_sk: i._notes, additional_camp_notes_en: i._notes__en,
                        required_spoken_language: i._languages, country: country,
                        organization_id: organization.try(:id), notes: i.id
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
        self.create_fees(i, event)
        self.create_worktypes(i, event)
      else
        error_message = ""
        if event.errors.any?
          error_message = event.errors.full_messages.join(', ')
        end
        LogActivity.create(action: "Transformation: Workcamp -> Event", what: "Error, message: #{error_message}")
      end
    end
    LogActivity.create(action: "Transformation: Workcamp -> Event", what: "Error, These organizations were not found: #{wrong_orgs.sort.uniq.join(',')}") if wrong_orgs.any?
  end

  def self.create_chiefs(i, event)
    # Find local partner from _contact_fullname, _contact_phone, _contact_email
    if !i._contact_fullname.blank? && i._contact_email.blank?
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
    end
    # All other chiefs in i_chiefs table
    i.i_cheifs.each do |c|
      user = User.where(name: c._name).where(surname: c._surname.downcase.capitalize)
      user = User.where(login_mail: c._email) if !user.any? # try also join via email
      if user.count == 0 # User will be created from i_chief data
        self.create_user_from_chief_data(c)
      elsif user.count > 1
        LogActivity.create(action: "Transformation: Workcamp -> Event, Cheif -> User", what: "Error, message: More than one user for #{c._name} #{c._surname}")
      else # only one user -> OK
        user = user.take
        if c._chief_role_id == 1 # Leader
          event.leaders.create(user: user)
        elsif c._chief_role_id == 2 # Local partner
          event.local_partners.create(user: user)
        else
          LogActivity.create(action: "Transformation: Workcamp -> Event, Cheif -> User", what: "Error, message: Unknown chief role id: #{c._chief_role_id}")
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
      LogActivity.create(action: "Transformation: Workcamp -> Event, Cheif -> User", what: "Error, message: #{message}")
    end
  end

  # _extrafee+_extrafee_curr+_price (tu ignoruj), _participation_fee_curr, _participation_fee,
  def self.create_fees(i, event)
    if !i._extrafee.blank?
      event.extra_fees.create(name: "Extra fee", amount: i._extrafee, currency: i._extrafee_curr)
    end
    if !i._participation_fee.blank?
      event.extra_fees.create(name: "Participation fee", amount: i._participation_fee, currency: i._participation_fee_curr)
    end
  end

  #_work = Workcamp kody (_work.split(',').reduce(&:blank?)), _workcodes (V speci tvare, preco nie :D #ENVI#RENO#STUDY#)
  # Worktypes: _disabled_vols, _vegetarian, _family,_accesibility
  def self.create_worktypes(i, event)
    work = (i._work.split(',') + i._workcodes.split('#')).reject(&:blank?).uniq
    work ||= []
    work << "DISA" if i._disabled_vols == true
    work << "VEGETARIAN" if i._vegetarian == true
    work << "FAMILY" if i._family == true
    work << "ACCESSIBILITY" if i._accessibility == true

    work.each do |w|
      abbr = EventCategory.where(abbr: w).take
      abbr = EventCategory.create(name: w, abbr: w) if !abbr
      event.event_with_categories.create(event_category_id: abbr.id)
    end
  end

  def self.organization_fix(name)
    orgs = {
      " FSL- INDIA": "FSL India",
      "alt": "Alternative-V",
      "Alternative V": "Alternative-V",
      "Compagnons Batisseurs": "Compagnons Batisseurs Belgium",
      "concf": "Concordia Fr",
      "CONCF": "Concordia Fr",
      "Concordia France": "Concordia Fr",
      "CONCORDIA UK": "CONCUK",
      "Concordia UK": "CONCUK",
      "BG-CVS": "CVS Bulgaria",
      "DaLaa Thailand": "DALAA",
      "TH-DA": "DALAA",
      "THA-DA": "DALAA",
      "De Amicitia": "De_Amicitia",
      "FSL- INDIA": "FSL India",
      "FSL-INDIA": "FSL India",
      "TR-GSM": "GSM",
      "SE-IAL": "IAL Svédsko",
      "Internationale Begegnung in Gemeinschaftsdiensten": "IBG",
      "IIWC of PKBI": "IIWC",
      "INDONESIA INTERN. WORKCAMPS": "IIWC",
      "CZ-INE 13.3": "INEX SDA",
      "CZ-INE 13.4": "INEX SDA",
      "INEX-SDA": "INEX SDA",
      "INEX Slovakia": "INEX SK",
      "InformaGiovani - IG": "InformaGiovani",
      "PT-IPJ": "IPJ",
      "AU-IVP": "IVP Australia",
      "IWO WORKCAMPS": "IWO",
      "Jeunesse et Reconstruction": "JR France",
      "JR": "JR France",
      "LEG": "Legambiente",
      "Legambiente ONLUS": "Legambiente",
      "MONGOLIAN WORKCAMPS EXCHANGE": "MCE",
      "MS ActionAid Denmark": "MS",
      "NICE (Neverending International workCamps Exchange)": "NICE",
      "NICE Japan": "NICE",
      "PRO": "Pro International",
      "SCI Catalonia": "SCI Catalunya",
      "SCI-CAT": "SCI Catalunya",
      "FR-SCI": "SCI France",
      "DE-SCI": "SCI Germany",
      "GR-SCI": "SCI Hellas",
      "IT-SCI": "SCI Italy",
      "US-SCI": "SCI USA",
      "BE-SCI": "SCI-Belgium",
      "SCI Madrid": "SCI-Madrid",
      "PL-SCI": "SCI-Poland",
      "IS-SEE": "Seeds",
      "Seeds Iceland": "Seeds",
      "SEEDS Iceland": "Seeds",
      "Movement SFERA": "SFERA",
      "SFERA Movement": "SFERA",
      "sod": "Sodrujestvo",
      "SOD": "Sodrujestvo",
      "UA-SVI": "SVIT-Ukraine",
      "UNION FORUM": "UF",
      "IVS GB": "UK-IVS",
      "VFP	USA": "USA VFP",
      "VFP": "USA VFP",
      "Volunteers For Peace USA": "USA VFP",
      "Volunteer Action for Peace": "VAP UK",
      "HR-VCZ": "VCZ Croatia",
      "Volunteers Initiative Nepal (VIN)": "VIN Nepal",
      "Vereinigung Junger Freiwilliger e.V.": "VJF Germany",
      "VJF": "VJF Germany",
      "VolTra Hong Kong": "Voltra",
      "IE-VSI": "VSI Ireland",
      "VYA": "VYA TAiwan",
      "WF": "World wide friends",
      "WF Iceland": "World wide friends",
      "Worldwide friends": "World wide friends",
      "Workcamp Switzerland": "WS Switzerland",
      "VOLUNTARY SERVICE SERBIA": "YRS VSS",
      "ACIWC": "ACI",
      "ALLI": "Alliansi",
      "ALLIANSSI YOUTH EXCHANGES": "Alliansi",
      "ANEC": "Etudes et Chantiers",
      "anec": "Etudes et Chantiers",
      "Cambodian	Youth	Action	(CYA)": "Cambodian Youth Action (CYA)",
      "CYA": "Cambodian Youth Action (CYA)",
      "COCAT": "COCAT Catalunya",
      "ES-CAT": "SCI Catalunya",
      "ES-MAD": "SCI-Madrid",
      "EST": "Estyes",
      "Foundation for International Youth Exchange": "FIYE",
      "Gerakan Kerelawanan Internasional": "GREAT",
      "GIED": "Global Initiative for Exchange and Development (GIED)",
      "CH-SCI": "SCI Switzerland",
      "Chantiers Jeunesse": "CJ",
      "IG": "InformaGiovani",
      "Open Houses": "OH",
      "Para Onde": "Para Onde (PT-OND)",
      "PT-OND": "Para Onde (PT-OND)",
      "RU-PZ": "Passage-Zebra",
      "SCI Sri Lanka": "LK-SCI",
      "Solidarites Jeunesses": "SJ",
      "UG-UPA": "Uganda Pioneers",
      "LS": "Leaders",
      "Volunteers for Peace": "USA VFP",
      "VOLUNTEERS FOR PEACE VIETNAM": "VPV",
      "VSA": "VSA Thailand",
      "WORLD4U": "W4U",
      "VSA Tailand": "VSA Thailand"
    }
    res = orgs[:"#{name}"]
    res ||= name
    res
  end

  def self.diff_workcodes
    IWorkcamp.all.each do |i|
      work = i._work.split(',').reject(&:blank?)
      workcodes = i._workcodes.split('#').reject(&:blank?)
      if work.size != workcodes.size
        p "#{work}<->#{workcodes}" if !work.blank?
      else
        work.each do |w|
          if !workcodes.include?(w)
            p "#{work}<->#{workcodes}" if !work.blank?
            next
          end
        end
      end
    end
  end
end