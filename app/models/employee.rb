class Employee < ActiveRecord::Base
  belongs_to :user

  has_many :tasks, dependent: :destroy
  has_many :contact_lists # Do not destroy - mozu ich vidiet ostatni

  has_many :employee_with_knowledges, dependent: :destroy
  has_many :knowledges, through: :employee_with_knowledges

  has_many :events # Zodpovedny za udalosti

  def nickname_or_name
    user.try(:nickname_or_name)
  end
end
