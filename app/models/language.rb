class Language < ActiveRecord::Base
  has_many :language_skills # do not destroy
end
