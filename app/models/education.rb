class Education < ActiveRecord::Base
  has_many :users
  has_many :event_lists
end
