class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, limit: 64
      t.text :description, limit: 2048
      t.string :country, limit: 128

      t.timestamps null: false
      t.attachment :image
    end
  end
end
