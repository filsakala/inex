class ChangeContentLimitOfHtmlArticles < ActiveRecord::Migration
  def change
    change_column :html_articles, :content, :text, :limit => 65536
  end
end
