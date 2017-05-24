class IOrganization2 < DatabaseTransformator
  self.table_name = "i_organization2"
  # Ignore:
  # OK: id, createdtime, modifiedtime, _title, alliance.id = _alliance_id, country.id = _country_id, _email
  # Transformuje IAlliance! Ale tuto konkretne ignoruje
  belongs_to :i_code_country, :foreign_key => '_country_id'

  def self.transform
    p "Organizacie transformuje IAlliance"
  end
end