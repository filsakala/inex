class CreateEventInLists < ActiveRecord::Migration
  def change
    create_table :event_in_lists do |t|
      t.belongs_to :event, index: true
      t.belongs_to :event_list, index: true

      t.string :state, limit: 128
      t.integer :priority # sorting priority

      t.timestamps null: false
    end
  end
end
