class Organization < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300>" },
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  has_many :organization_in_networks, dependent: :destroy
  has_many :partner_networks, through: :organization_in_networks

  has_many :contacts # Do not destroy!
  has_many :events # If you destroy Org., you don't want to destroy events

  accepts_nested_attributes_for :contacts, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? || attributes['surname'].blank? }

  validates_presence_of :name, message: I18n.t(:title_have_to_be_filled)
end
