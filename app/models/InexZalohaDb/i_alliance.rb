class IAlliance < DatabaseTransformator
  self.table_name = "i_alliance"
  # Ignore:
  # OK: id, _title
  # Transformuj do partner_network
  # transform safe
  has_many :i_organizations, :foreign_key => '_alliance_id'
  has_many :i_organizations2, :foreign_key => '_alliance_id'

  def self.transform
    IAlliance.all.each do |a|
      p = PartnerNetwork.new(name: a._title)
      if p.save
        # LogActivity.create(action: "Transformation: Alliance -> PartnerNetwork", what: "Success, id: #{p.id}")
        self.transform_organizations(a, p)
      else
        error_message = ""
        if p.errors.any?
          error_message = p.errors.full_messages.join(', ')
        end
        LogActivity.create(action: "Transformation: Alliance -> PartnerNetwork", what: "Error, message: #{error_message}")
      end
    end
    # Create organizations for workcamps:
    self.organization_pre_fix
  end

  # Transformuje IOrganization, IOrganization2 v IAlliance
  #           do Organization v PartnerNetwork
  def self.transform_organizations(alliance, partner_network)
    alliance.i_organizations.each do |o|
      organization = Organization.new(
        name: o._title.strip,
        description: o._email,
        country: o.i_code_country.try(:_title__en)
      )
      if organization.save
        partner_network.organization_in_networks.create(organization: organization)
      else
        LogActivity.create(action: "Transformation: Alliance -> PartnerNetwork", what: "Error, message: Organization error")
      end
    end
  end

  def self.organization_pre_fix
    Organization.create([
                          { name: "ACI", country: "Costa Rica" },
                          { name: "Etudes et Chantiers", country: "France" },
                          { name: "BD-SCI", country: "Bangladesh" },
                          { name: "Cambodian Youth Action (CYA)", country: "Cambodia" },
                          { name: "Dreamwalker", country: "China" },
                          { name: "Egyesek Youth Organisation", country: "Hungary" },
                          { name: "GREAT", country: "Indonesia" },
                          { name: "GH-VOL", country: "Ghana" },
                          { name: "Global Initiative for Exchange and Development (GIED)", country: "Philippines" },
                          { name: "HR-VAK", country: "Croatia" },
                          { name: "HU-SCI", country: "Hungary" },
                          { name: "ICJA", country: "Germany" },
                          { name: "ID-IVP", country: "Indonesia" },
                          { name: "KS-GAI", country: "Kosovo" },
                          { name: "LK-SCI", country: "Sri Lanka" },
                          { name: "LU-APL", country: "Luxembourg" },
                          { name: "Para Onde (PT-OND)", country: "Portugal" },
                          { name: "RS-SCI", country: "Serbia" },
                          { name: "Ruchi", country: "India" },
                          { name: "SCI HK China", country: "China" },
                          { name: "SI-SCI", country: "Slovenia" },
                          { name: "SJ Vietnam", country: "Slovenia" },
                          { name: "Smart Travel Bureau", country: "Russia" },
                          { name: "Uganda Pioneers", country: "Uganda" },
                          { name: "UK-IE-VSI", country: "United Kingdom" },
                          { name: "UVIKIUTA Tanzania", country: "Tanzania" },
                          { name: "VSA Thailand", country: "Thailand" }
                        ])
    Organization.where(country: "Kirgistan").each do |o|
      o.update(country: "Kyrgyzstan")
    end
  end
end