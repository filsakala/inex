class Task < ActiveRecord::Base
  belongs_to :employee
  has_many :task_lists, dependent: :destroy

  accepts_nested_attributes_for :task_lists, allow_destroy: true,
                                reject_if:                  proc { |attributes| attributes['title'].blank? || attributes['state'].blank? }
  validates_presence_of :title, message: I18n.t(:title_have_to_be_filled)

  def self.create_this_task_for_users(users = [], task_params = nil)
    users.each do |user|
      if user.is_inex_office?
        task               = Task.new(task_params)
        task.employee      = user.employee
        task.is_repeatable = false
        task.save
      end
    end
  end

  def is_done?
    task_lists.where(state: 'nedokončená').count == 0
  end

  def self.include_done_task_list_counts
    joins(
      %{
       LEFT OUTER JOIN (
         SELECT t.task_id, COUNT(*) done_task_list_count
         FROM   task_lists t
         WHERE t.state = "dokončená"
         GROUP BY t.task_id
       ) a ON a.task_id = tasks.id
     }
    ).select("tasks.*, COALESCE(a.done_task_list_count, 0) AS done_task_list_count")
  end

  def self.include_task_list_counts
    joins(
      %{
       LEFT OUTER JOIN (
         SELECT t.task_id, COUNT(*) task_list_count
         FROM   task_lists t
         GROUP BY t.task_id
       ) b ON b.task_id = tasks.id
     }
    ).select("tasks.*, COALESCE(b.task_list_count, 0) AS task_list_count")
  end
end
