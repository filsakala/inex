class CreateEventRowAssociations < ActiveRecord::Migration
  def change
    create_table :event_row_associations do |t|
      t.string :my, limit: 256
      t.string :their_1, limit: 256
      t.string :their_2, limit: 256
      t.string :their_3, limit: 256

      t.timestamps null: false
    end
  end
end
