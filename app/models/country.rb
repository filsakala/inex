class Country < ActiveRecord::Base

  def self.flag_by_name(name)
    Country.where(name: name).take.try(:flag_code)
  end

  def self.flag_codes_for_countries(countries = [])
    Hash[ Country.where(name: countries.uniq).collect { |c| [c.name, c.flag_code] }]
  end
end
