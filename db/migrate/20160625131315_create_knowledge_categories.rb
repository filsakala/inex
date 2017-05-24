class CreateKnowledgeCategories < ActiveRecord::Migration
  def change
    create_table :knowledge_categories do |t|
      t.string :category, limit: 128

      t.timestamps null: false
    end
  end
end
