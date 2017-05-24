class CreateContactInLists < ActiveRecord::Migration
  def change
    create_table :contact_in_lists do |t|
      t.belongs_to :contact, index: true
      t.belongs_to :contact_list, index: true

      t.timestamps null: false
    end
  end
end
