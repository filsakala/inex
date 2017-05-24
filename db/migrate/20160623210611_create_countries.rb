class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, limit: 128
      t.string :flag_code, limit: 32

      t.timestamps null: false
    end
  end
end
