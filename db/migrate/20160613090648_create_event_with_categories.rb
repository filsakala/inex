class CreateEventWithCategories < ActiveRecord::Migration
  def change
    create_table :event_with_categories do |t|
      t.belongs_to :event_category, index: true
      t.belongs_to :event, index: true

      t.timestamps null: false
    end
  end
end
