class EventColumnSet < ActiveRecord::Base
  has_many :event_columns

  # Najde set, ktory koresponduje s headerom
  def self.find_set(header_row = [])
    EventColumnSet.includes(:event_columns).where(their: header_row)
  end

  # after_create :check_columns

  def check_columns
    raise event_columns.where(my: "from").inspect
  end
end
