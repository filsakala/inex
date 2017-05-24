class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :event_list
end
