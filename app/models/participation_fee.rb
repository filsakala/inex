class ParticipationFee < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_list

  validates_presence_of :user_id, message: I18n.t(:payer_have_to_be_filled)
end
