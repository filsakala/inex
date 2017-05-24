class PartnerNetwork < ActiveRecord::Base
  has_many :organization_in_networks, dependent: :destroy
  has_many :organizations, through: :organization_in_networks

  validates_presence_of :name, message: 'Nebol zadaný názov.'
end
