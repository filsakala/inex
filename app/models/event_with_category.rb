class EventWithCategory < ActiveRecord::Base
  belongs_to :event_category
  belongs_to :event
end
