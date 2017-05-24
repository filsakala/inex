class CreateEventColumns < ActiveRecord::Migration
  def change
    create_table :event_columns do |t|
      t.belongs_to :event_column_set, index: true
      t.string :my
      t.string :their

      t.timestamps null: false
    end
  end
end
