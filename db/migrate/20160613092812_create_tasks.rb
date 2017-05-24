class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.belongs_to :employee, index: true

      t.string :title, limit: 128
      t.text :description, limit: 2048
      t.boolean :is_repeatable
      t.boolean :is_highlighted
      t.date :deadline

      t.timestamps null: false
    end
  end
end
