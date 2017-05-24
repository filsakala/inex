class CreateHomepagePartners < ActiveRecord::Migration
  def change
    create_table :homepage_partners do |t|
      t.string :img_url, limit: 128
      t.text :text, limit: 2048
      t.string :url, limit: 256

      t.timestamps null: false
      t.attachment :image
    end
  end
end
