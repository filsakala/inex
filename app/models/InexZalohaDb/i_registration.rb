class IRegistration < DatabaseTransformator
  self.table_name = "i_registration"
  # Barbina tabulecka -> mozes asi spravit EventTypeTable s tymi stlpcami:
  # _title, _camp_id (i_camp.id), _code, _vs, _fullname, _male (0/1), _female (0/1),
  # _country, _birthdate, _email, _phone, _sending_org, _organization_id, _organization_email, _acceptance_mail_sent (0/1)
  # _acceptance_mail_sent_date, _motivational_letter, _motivational_letter_date,
  # _confirmation_slip, _confirmation_slip_date, _need_visa (0/1), _need_visa_date,
  # _got_visa, _got_visa_date, _parental_authorization (0/1), _parental_authorization_date,
  # _infosheet, _infosheet_date, _extra_fee, _extra_fee_date, _extra_fee_price, _storno
  # _storno_date, _no_show, _gender, _country_id, _note
end