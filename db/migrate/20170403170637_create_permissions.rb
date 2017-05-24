class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :role
      t.string :controller
      t.string :action

      t.timestamps null: false
    end
  end
end
