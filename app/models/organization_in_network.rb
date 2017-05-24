class OrganizationInNetwork < ActiveRecord::Base
  belongs_to :organization
  belongs_to :partner_network
end
