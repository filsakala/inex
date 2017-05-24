class Knowledge < ActiveRecord::Base
  has_many :employee_with_knowledges, dependent: :destroy
  has_many :employees, through: :employee_with_knowledges

  has_many :knowledge_in_categories, dependent: :destroy
  has_many :knowledge_categories, through: :knowledge_in_categories

  validates_presence_of :title, message: I18n.t(:title_have_to_be_filled)

  def category_ids
    knowledge_categories.pluck(:id)
  end
end
