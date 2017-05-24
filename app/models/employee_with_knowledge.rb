class EmployeeWithKnowledge < ActiveRecord::Base
  belongs_to :employee
  belongs_to :knowledge
end
