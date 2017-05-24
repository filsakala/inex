class ContactInList < ActiveRecord::Base
  belongs_to :contact
  belongs_to :contact_list
end
