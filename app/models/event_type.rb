class EventType < ActiveRecord::Base
  belongs_to :super_event_type
  has_many :events, dependent: :nullify # If you destroy Ev. T., you don't want to destroy events
  has_many :event_tables, dependent: :destroy
  belongs_to :employee # Zodpovedny za udalosti

  validates :title, presence: { message: I18n.t(:title_have_to_be_filled) }
end
