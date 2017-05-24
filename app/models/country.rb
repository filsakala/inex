class Country < ActiveRecord::Base

  def self.flag_by_name(name)
    c = Country.where(name: name).take
    c.flag_code if c
  end
end
