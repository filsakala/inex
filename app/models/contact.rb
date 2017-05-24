class Contact < ActiveRecord::Base
  belongs_to :organization

  has_many :contact_in_lists, dependent: :destroy
  has_many :contact_lists, through: :contact_in_lists

  validates_presence_of :name, message: I18n.t(:name_have_to_be_filled)
  validates_presence_of :surname, message: I18n.t(:name_have_to_be_filled)
end
