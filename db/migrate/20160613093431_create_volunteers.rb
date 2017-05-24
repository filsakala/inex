class CreateVolunteers < ActiveRecord::Migration
  def change
    create_table :volunteers do |t|
      t.belongs_to :event, index: true
      t.belongs_to :event_list, index: true

      t.timestamps null: false
    end
  end
end
