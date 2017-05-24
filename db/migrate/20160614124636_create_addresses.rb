class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.belongs_to :user, index: true
      t.belongs_to :event_list, index: true

      t.string :title, limit: 128
      t.text :address, limit: 512
      t.string :postal_code, limit: 32
      t.string :city, limit: 128
      t.string :country, limit: 128

      t.timestamps null: false
    end
  end
end
