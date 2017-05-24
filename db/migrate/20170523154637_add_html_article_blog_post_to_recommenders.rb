class AddHtmlArticleBlogPostToRecommenders < ActiveRecord::Migration
  def change
    add_reference :recommenders, :html_article, index: true
    add_foreign_key :recommenders, :html_articles
    add_reference :recommenders, :blog_post, index: true
    add_foreign_key :recommenders, :blog_posts
  end
end
