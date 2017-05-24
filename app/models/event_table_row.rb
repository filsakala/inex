class EventTableRow < ActiveRecord::Base
  belongs_to :event_table
  has_many :event_table_columns, dependent: :destroy

  # Params: column name, value, color, value type (string, boolean, date)
  def add(columns = [])
    columns.each do |column|
      if column[:name] && column[:value]
        etc = event_table_columns.new(name: column[:name], value: column[:value])
        etc.color = column[:color]
        etc.save
      end
    end
  end
end
