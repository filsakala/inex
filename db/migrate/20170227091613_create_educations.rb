class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :etype
      t.string :name_sk
      t.string :name_en

      t.timestamps null: false
    end
  end
end
