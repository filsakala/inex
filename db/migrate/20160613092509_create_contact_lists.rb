class CreateContactLists < ActiveRecord::Migration
  def change
    create_table :contact_lists do |t|
      t.belongs_to :employee, index: true
      t.string :title, limit: 128

      t.timestamps null: false
    end
  end
end
