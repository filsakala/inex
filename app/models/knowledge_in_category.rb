class KnowledgeInCategory < ActiveRecord::Base
  belongs_to :knowledge
  belongs_to :knowledge_category
end
