class IOrganization < DatabaseTransformator
  self.table_name = "i_organization"
  # OK: id, _title, alliance.id = _alliance_id, country.id = _country_id, _email
  # Transformuje IAlliance!
  belongs_to :i_code_country, :foreign_key => '_country_id'

  def self.transform
    p "Organizacie transformuje IAlliance"
  end
end