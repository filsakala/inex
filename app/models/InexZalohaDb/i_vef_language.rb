class IVefLanguage < DatabaseTransformator
  self.table_name = "i_vef_language"
  # ok: parentid, _title, _skill (1/2/3/4)
  # u mna: level: ["Mother tongue", "Very good", 'Good', 'Basic']

  def self.fix_language(l)
    l = l.strip.capitalize
    case l
      when "En", "Englist", "Englisch", "English language", "Englsh", "Angličtina"
        return "English"
      when "De", "Germen", "Germany", "Deutsch"
        return "German"
      when "Pl"
        return "Polish"
      when "Sk", "Slovak language", "Slovenský", "Slovakian", "Slovenčina"
        return "Slovak"
      when "Slovene"
        return "Slovenian"
      when "Norge"
        return "Norwegian"
      else
        l
    end
  end
end