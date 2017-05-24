class HomepageCard < ActiveRecord::Base
  has_attached_file :image_1, :styles => { :medium => "300x300>" },
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :image_2, :styles => { :medium => "300x300>" },
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :image_3, :styles => { :medium => "300x300>" },
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :image_4, :styles => { :medium => "300x300>" },
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :image_5, :styles => { :medium => "300x300>" },
                    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
                    :url => "/system/:attachment/:id/:style/:filename"
  validates_attachment_content_type :image_1, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :image_2, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :image_3, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :image_4, content_type: /\Aimage\/.*\Z/
  validates_attachment_content_type :image_5, content_type: /\Aimage\/.*\Z/

  default_scope { order("priority ASC") }

  before_create :set_priority

  def set_priority
    last_priority = HomepageCard.order(:priority).last.try(:priority)
    if last_priority
      self.priority = last_priority + 1
    else
      self.priority = 0
    end
  end

  # Select one image for this week
  def selected_image
    images = [image_1, image_2, image_3, image_4, image_5].reject(&:blank?)
    week_now = Time.now.strftime("%U").to_i
    if images.any?
      images[week_now % images.size]
    else
      nil
    end
  end
end
