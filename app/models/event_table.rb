class EventTable < ActiveRecord::Base
  belongs_to :event_type

  has_many :event_table_rows, dependent: :destroy
  has_many :event_table_columns, through: :event_table_rows

  def add_to_header(columns = [])
    row = event_table_rows.where(is_header: true).take
    row = event_table_rows.create(is_header: true) if !row
    old_priority = row.event_table_columns.size # calc only once
    columns.each_with_index do |column, index|
      priority = old_priority + index + 1
      row.event_table_columns.create(name: column[:name], ctype: column[:type], priority: priority)
    end
  end

  def delete_from_header(columns = [])
    event_table_columns.where(name: columns).destroy_all
  end

  # build row-column table -> each row, each column
  def build_table
    result = {}
    result[:rows] = []
    result[:header] = []
    unless event_table_rows.blank?
      # Header
      row = event_table_rows.where(is_header: true).take
      if row
        result[:header] = row.event_table_columns
      end
      # Other
      rows = event_table_rows.where(is_header: false) + event_table_rows.where(is_header: nil)
      rows.each do |row|
        actual_row = {}
        actual_row[:row] = row
        row.event_table_columns.each do |column|
          actual_row[column.name] = column
        end
        result[:rows] << actual_row
      end

      # FIX missing columns
      result[:rows].each do |row|
        result[:header].each do |header|
          if row[header.name].blank?
            if header.ctype == "boolean"
              row[:row].add([{ name: header.name, value: 'false' }])
            else
              row[:row].add([{ name: header.name, value: 'click to edit' }])
            end
          end
        end
      end
    end
    result
  end

end
