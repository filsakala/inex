class CreateEventCategoryAlliances < ActiveRecord::Migration
  def change
    create_table :event_category_alliances do |t|
      t.belongs_to :event_category, index: true
      t.string :name, limit: 128

      t.timestamps null: false
    end
  end
end
