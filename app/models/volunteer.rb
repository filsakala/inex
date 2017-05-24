class Volunteer < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_list
end
