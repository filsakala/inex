class IPaymentInfo < DatabaseTransformator
  self.table_name = "i_payment_info"
  # Platba k prihlaske za clena
  # OK: parentid (i_member_application.id), _vs, _price, _paid_at, _type (i_payment_type.id)
  # parentclass: course_app, _member_application, _vef_reg
  belongs_to :i_payment_type, :foreign_key => '_type'
end