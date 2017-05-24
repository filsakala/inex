class EventCategory < ActiveRecord::Base
  has_many :event_with_categories, dependent: :destroy
  has_many :events, through: :event_with_categories

  has_many :event_category_alliances, dependent: :destroy
  has_many :event_category_scis, dependent: :destroy

  accepts_nested_attributes_for :event_category_alliances, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :event_category_scis, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }
end
