class EventInList < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_list

  default_scope { order("priority ASC") }
end
