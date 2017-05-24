class EventTableColumn < ActiveRecord::Base
  belongs_to :event_table_row
  default_scope { order("priority ASC") }

  # name, value, color, priority

  def self.color_list
    {
      green: 'positive',
      yellow: 'warning',
      red: 'negative'
    }
  end

  def typed_value
    if ctype == "boolean"
      return true if value == 'true'
      return false if value == 'false'
    elsif ctype == "date"
      return Date.parse(value).strftime("%d.%m.%Y")
    end
    return value # else string
  end
end
