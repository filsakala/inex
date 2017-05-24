class CreateKnowledges < ActiveRecord::Migration
  def change
    create_table :knowledges do |t|
      t.string :title, limit: 128
      t.text :text, limit: 2048
      t.string :keywords, limit: 128

      t.timestamps null: false
    end
  end
end
