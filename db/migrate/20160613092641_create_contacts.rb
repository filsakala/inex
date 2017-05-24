class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.belongs_to :organization, index: true

      t.string :name, limit: 128
      t.string :nickname, limit: 128
      t.string :mail, limit: 128
      t.string :phone, limit: 128
      t.string :other_contacts, limit: 128
      t.string :dept, limit: 128
      t.text :notes, limit: 2048

      t.timestamps null: false
    end
  end
end
