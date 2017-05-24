module ContactsHelper
  def name_nickname_format(contact)
    unless contact.nickname.blank?
      "#{contact.name} #{contact.surname} (#{contact.nickname})"
    else
      "#{contact.name} #{contact.surname}"
    end
  end
end
