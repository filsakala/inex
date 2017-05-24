class CreateRecommendationResults < ActiveRecord::Migration
  def change
    create_table :recommendation_results do |t|
      t.belongs_to :recommender, index: true

      t.string :title, limit: 1024
      t.string :thumbnail_url, limit: 1024
      t.string :url, limit: 1024

      t.timestamps null: false
    end
  end
end
