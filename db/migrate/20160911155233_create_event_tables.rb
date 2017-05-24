class CreateEventTables < ActiveRecord::Migration
  def change
    create_table :event_tables do |t|
      t.belongs_to :event_type, index: true

      t.string :name, limit: 128

      t.timestamps null: false
    end
  end
end
