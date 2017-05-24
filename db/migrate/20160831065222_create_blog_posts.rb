class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.belongs_to :blog_post_category, index: true

      t.string :title, limit: 128
      t.text :perex, limit: 1024
      t.text :text, limit: 2048
      t.boolean :is_published

      t.timestamps null: false
      t.attachment :image
    end
  end
end
