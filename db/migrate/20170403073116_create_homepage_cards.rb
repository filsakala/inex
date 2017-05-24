class CreateHomepageCards < ActiveRecord::Migration
  def change
    create_table :homepage_cards do |t|
      t.string :title
      t.string :url
      t.integer :priority
      t.boolean :is_visible
      t.attachment :image_1
      t.attachment :image_2
      t.attachment :image_3
      t.attachment :image_4
      t.attachment :image_5

      t.timestamps null: false
    end
  end
end
