class CreateTaskLists < ActiveRecord::Migration
  def change
    create_table :task_lists do |t|
      t.belongs_to :task, index: true

      t.string :title, limit: 128
      t.text :description, limit: 2048
      t.string :state, limit: 128

      t.timestamps null: false
    end
  end
end
