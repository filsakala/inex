class Task < ActiveRecord::Base
  belongs_to :employee
  has_many :task_lists, dependent: :destroy

  accepts_nested_attributes_for :task_lists, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['title'].blank? || attributes['state'].blank? }
  validates_presence_of :title, message: I18n.t(:title_have_to_be_filled)

  def self.create_this_task_for_users(users = [], task_params = nil)
    users.each do |user|
      if user.is_inex_member?
        task = Task.new(task_params)
        # task.title += " (#{user.nickname})"
        task.employee = user.employee
        task.is_repeatable = false
        task.save
      end
    end
  end

  def is_done?
    task_lists.where(state: 'nedokončená').count == 0
  end
end
