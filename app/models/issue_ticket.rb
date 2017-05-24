class IssueTicket < ActiveRecord::Base
  has_attached_file :image,
                    :path => ":rails_root/public/system/:attachment/:id/:filename",
                    :url => "/system/:attachment/:id/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  default_scope { order(priority: :asc).order(created_at: :desc) }
  belongs_to :user
end
