class BlogPost < ActiveRecord::Base
  has_attached_file :image, :styles => { :medium => "300x300>" },
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  validates_presence_of :title, message: I18n.t(:title_have_to_be_filled)
  belongs_to :blog_post_category
  has_one :recommender
end
