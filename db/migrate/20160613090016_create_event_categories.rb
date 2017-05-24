class CreateEventCategories < ActiveRecord::Migration
  def change
    create_table :event_categories do |t|
      t.string :name, limit: 128
      t.string :abbr, limit: 32

      t.timestamps null: false
    end
  end
end
