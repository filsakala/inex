class KnowledgeCategory < ActiveRecord::Base
  has_many :knowledge_in_categories, dependent: :destroy
  has_many :knowledges, through: :knowledge_in_categories

  validates_presence_of :category, message: I18n.t(:title_have_to_be_filled)

  def knowledges_i_can_see(employee)
    joined_knowledges = knowledges.joins(:employee_with_knowledges)
    with_emps = joined_knowledges.where(employee_with_knowledges: { employee_id: employee.id })
    without_emps = knowledges - joined_knowledges
    with_emps + without_emps
  end
end
