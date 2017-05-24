class LanguageSkill < ActiveRecord::Base
  belongs_to :event_list
  belongs_to :language
end
