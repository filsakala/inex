class CreateOrganizationInNetworks < ActiveRecord::Migration
  def change
    create_table :organization_in_networks do |t|
      t.belongs_to :organization, index: true
      t.belongs_to :partner_network, index: true
      t.timestamps null: false
    end
  end
end
