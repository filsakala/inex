class CreateEventColumnSets < ActiveRecord::Migration
  def change
    create_table :event_column_sets do |t|

      t.timestamps null: false
    end
  end
end
