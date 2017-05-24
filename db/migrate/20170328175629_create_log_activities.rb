class CreateLogActivities < ActiveRecord::Migration
  def change
    create_table :log_activities do |t|
      t.belongs_to :user, index: true
      t.string :action
      t.string :what, limit: 4096

      t.timestamps null: false
    end
  end
end
