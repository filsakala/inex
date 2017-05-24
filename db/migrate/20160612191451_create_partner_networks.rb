class CreatePartnerNetworks < ActiveRecord::Migration
  def change
    create_table :partner_networks do |t|
      t.string :name, :limit => 64
      t.text :description, :limit => 2048

      t.timestamps null: false
    end
  end
end
