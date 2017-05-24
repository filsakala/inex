class CreateEventTableColumns < ActiveRecord::Migration
  def change
    create_table :event_table_columns do |t|
      t.belongs_to :event_table_row, index: true

      t.string :name, limit: 128
      t.string :color, limit: 128
      t.text :value, limit: 1024
      t.string :ctype, limit: 128
      t.integer :priority

      t.timestamps null: false
    end
  end
end
