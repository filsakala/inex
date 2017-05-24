class CreateKnowledgeInCategories < ActiveRecord::Migration
  def change
    create_table :knowledge_in_categories do |t|
      t.belongs_to :knowledge, index: true
      t.belongs_to :knowledge_category, index: true

      t.timestamps null: false
    end
  end
end
