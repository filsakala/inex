class IPaymentType < DatabaseTransformator
  self.table_name = "i_payment_type"
  # Typ platby (hotovost, bankovy prevod, ...)
  # OK: id, _title, _title_en (ak toto treba?)
  # has_one :i_payment_info, :foreign_key => '_type'
end