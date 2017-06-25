class EventColumnSet < ActiveRecord::Base
  has_many :event_columns

  # Najde set, ktory koresponduje s headerom
  def self.find_set(header_row = [])
    EventColumnSet.includes(:event_columns).where(their: header_row)
  end
end
