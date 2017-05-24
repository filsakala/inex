class CreateHtmlArticles < ActiveRecord::Migration
  def change
    create_table :html_articles do |t|
      t.string :category, limit: 128
      t.string :title, limit: 128
      t.text :content, limit: 2048
      t.string :url, limit: 256

      t.timestamps null: false
    end
  end
end
