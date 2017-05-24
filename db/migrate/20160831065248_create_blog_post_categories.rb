class CreateBlogPostCategories < ActiveRecord::Migration
  def change
    create_table :blog_post_categories do |t|
      t.string :name, limit: 128
      t.string :color, limit: 128

      t.timestamps null: false
    end
  end
end
