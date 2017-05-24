class ICodeCountry < DatabaseTransformator
  self.table_name = "i_code_country"
  # Toto iba kvoli niektorym castiam (napr. Organizations, User...)
  # id, _title?, _title_en, _country_code?
  has_many :i_organizations, :foreign_key => '_country_id'
  has_many :i_organizations2, :foreign_key => '_country_id'
end