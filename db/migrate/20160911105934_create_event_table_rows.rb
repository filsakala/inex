class CreateEventTableRows < ActiveRecord::Migration
  def change
    create_table :event_table_rows do |t|
      t.belongs_to :event_table, index: true

      t.boolean :is_header
      t.timestamps null: false
    end
  end
end
