class ContactList < ActiveRecord::Base
  belongs_to :employee
  has_many :contact_in_lists, dependent: :destroy
  has_many :contacts, through: :contact_in_lists

  validates_presence_of :title, message: I18n.t(:title_have_to_be_filled)
end
